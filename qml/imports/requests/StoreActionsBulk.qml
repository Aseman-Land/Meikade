pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0
import queries 1.0

AsemanObject {

    readonly property bool syncing: storeReq.refreshing || actionsReq.refreshing || insertTimer.running || storeInterval.running
    property bool syncAgain

    Connections {
        target: GlobalSignals
        onSyncRequest: syncActionsInterval()
        onReinitSync: {
            syncActionsInterval();
            Tools.jsDelayCall(400, function(){
                controller.trigger("float:/syncs", {"allowResync": false})
            })
        }
    }

    StoreActionsBulkRequest {
        id: storeReq
        onSuccessfull: {
            AsemanGlobals.lastSync = Tools.dateToString(new Date, "yyyy-MM-dd hh:mm:ss");

            actions.begin();
            if (AsemanGlobals.syncTopPoets) actions.query("UPDATE actions SET synced = 1 WHERE type = " + UserActions.TypeTopPoets);
            if (AsemanGlobals.syncNotes) actions.query("UPDATE actions SET synced = 1 WHERE type = " + UserActions.TypeNote);
            if (AsemanGlobals.syncViews) actions.query("UPDATE actions SET synced = 1 WHERE type = " + UserActions.TypePoemViewDate +
                                                       " OR (type >= " + UserActions.TypeItemViewDiaryStart +
                                                       " AND type < " + UserActions.TypeItemViewDiaryEnd + " )");
            if (AsemanGlobals.syncMyPoems) actions.query("UPDATE actions SET synced = 1 WHERE type >= " + UserActions.TypeItemBooksStart +
                                                         " AND type < " + UserActions.TypeItemBooksEnd);
            if (AsemanGlobals.syncFavorites) actions.query("UPDATE actions SET synced = 1 WHERE type = " + UserActions.TypeFavorite +
                                                           " OR (type >= " + UserActions.TypeItemListsStart +
                                                           " AND type < " + UserActions.TypeItemListsEnd + " )");
            actions.commit();

            if (syncAgain) syncActionsInterval();
            syncAgain = false;
        }
    }

    UserActions {
        id: actions
    }

    MapObject {
        id: hash
    }

    GetActionsRequest {
        id: actionsReq
        date: AsemanGlobals.lastSync.length? AsemanGlobals.lastSync : "2020-01-01 00:00:00"
        onResponseChanged: {
            try {
                insertTimer.count = response.result.length;
                insertTimer.refreshNeeded = (insertTimer.count > 0)
                insertTimer.restart()
            } catch (e) {
                insertTimer.stop()
            }
        }
    }

    Timer {
        id: insertTimer
        interval: 1
        repeat: true
        onRunningChanged: running? actions.begin() : actions.commit()
        onTriggered: {
            count--;
            if (count < 0) {
                if (refreshNeeded) {
                    Tools.jsDelayCall(1000, function(){
                        GlobalSignals.recentPoemsRefreshed();
                        GlobalSignals.topPoetsRefreshed();
                        GlobalSignals.favoritesRefreshed();
                    })
                }

                uploadUnsyncedActions();
                stop();
                return;
            }

            try {
                var a = actionsReq.response.result[count];
                actions.poetId = a.poet_id;
                actions.catId = a.category_id;
                actions.poemId = a.poem_id;
                actions.verseId = a.verse_id;
                actions.type = a.type;

                switch (actions.type) {
                case UserActions.TypeFavorite:
                    if (!AsemanGlobals.syncFavorites)
                        return;
                    break;

                case UserActions.TypeNote:
                    if (!AsemanGlobals.syncNotes)
                        return;
                    break;

                case UserActions.TypePoetViewDate:
                case UserActions.TypeCatViewDate:
                case UserActions.TypePoemViewDate:
                    if (!AsemanGlobals.syncViews)
                        return;
                    break;

                case UserActions.TypeTopPoets:
                    if (!AsemanGlobals.syncTopPoets)
                        return;
                    break;

                case UserActions.TypeUnknown:
                case UserActions.TypeNote:
                default:
                    if (actions.type >= UserActions.TypeItemBooksStart && actions.type < UserActions.TypeItemBooksEnd && AsemanGlobals.syncMyPoems)
                        break;
                    else
                    if (actions.type >= UserActions.TypeItemListsStart && actions.type < UserActions.TypeItemListsEnd && AsemanGlobals.syncFavorites)
                        break;
                    else
                    if (actions.type >= UserActions.TypeItemViewDiaryStart && actions.type < UserActions.TypeItemViewDiaryEnd && AsemanGlobals.syncViews)
                        break;
                    else
                        return;
                }

                actions.updatedAt = 0;
                actions.synced = 1;
                actions.fetch();

                var updated_at = Tools.dateToSec( unNormalizeDate(a.updated_at) );
                if (actions.synced == 0 && actions.updatedAt > updated_at)
                    return;

                actions.declined = a.declined;
                actions.value = a.value;
                actions.extra = a.extra;
                actions.updatedAt = updated_at;
                actions.synced = 1;

                actions.push();
            } catch (e) {
            }
        }

        property int count
        property bool refreshNeeded
    }

    Timer {
        id: storeInterval
        interval: 3000
        repeat: false
        onTriggered: syncActions();
    }

    function init() {
        syncActionsInterval();
    }

    function syncActionsInterval() {
        if (AsemanGlobals.accessToken.length == 0)
            return;
        if (!AsemanGlobals.syncFavorites && !AsemanGlobals.syncTopPoets && !AsemanGlobals.syncViews && !AsemanGlobals.syncNotes && !AsemanGlobals.syncMyPoems)
            return;

        storeInterval.restart();
    }

    function forceResync() {
        AsemanGlobals.lastSync = "";
        actions.begin();
        actions.query("UPDATE actions SET synced = 0");
        actions.commit();
        syncActionsInterval();
    }

    function syncActions() {
        if (AsemanGlobals.accessToken.length == 0)
            return;
        if (actionsReq.refreshing || storeReq.refreshing) {
            syncAgain = true;
            return;
        }

        actionsReq.networkManager.get(actionsReq);
    }

    function uploadUnsyncedActions() {
        var items = actions.query("SELECT poetId as poet_id, catId as category_id, poemId as poem_id, verseId as verse_id, " +
                                  "type, declined, value, extra, updatedAt as updated_at, updatedAt as inserted_at " +
                                  "FROM actions WHERE synced = 0", {});
        if (items.length == 0) {
            AsemanGlobals.lastSync = Tools.dateToString(new Date, "yyyy-MM-dd hh:mm:ss");
            if (syncAgain) syncActionsInterval();
            syncAgain = false;
            return;
        }

        var acts = new Array
        for (var i in items) {
            var it = items[i];

            switch (it.type) {
            case UserActions.TypeFavorite:
                if (!AsemanGlobals.syncFavorites)
                    continue;
                break;

            case UserActions.TypeNote:
                if (!AsemanGlobals.syncNotes)
                    continue;
                break;

            case UserActions.TypePoetViewDate:
            case UserActions.TypeCatViewDate:
            case UserActions.TypePoemViewDate:
                if (!AsemanGlobals.syncViews)
                    continue;
                break;

            case UserActions.TypeTopPoets:
                if (!AsemanGlobals.syncTopPoets)
                    continue;
                break;

            case UserActions.TypeUnknown:
            case UserActions.TypeNote:
            default:
                if (it.type >= UserActions.TypeItemBooksStart && it.type < UserActions.TypeItemBooksEnd && AsemanGlobals.syncMyPoems)
                    break;
                if (it.type >= UserActions.TypeItemListsStart && it.type < UserActions.TypeItemListsEnd && AsemanGlobals.syncFavorites)
                    break;
                else
                if (it.type >= UserActions.TypeItemViewDiaryStart && it.type < UserActions.TypeItemViewDiaryEnd && AsemanGlobals.syncViews)
                    break;
                continue;
            }

            it.updated_at = normalizeDate( Tools.dateFromSec(it.updated_at) );
            it.inserted_at = normalizeDate(new Date);

            acts[acts.length] = Tools.toVariantMap(it);
        }

        storeReq.actions = acts;
        storeReq.networkManager.post(storeReq);
    }

    function normalizeDate(date) {
        return date.toISOString();
    }

    function unNormalizeDate(dateStr) {
        return Tools.dateFromSec( Math.floor(Date.parse(dateStr) / 1000) );
    }
}
