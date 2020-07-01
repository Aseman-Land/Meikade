pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0
import queries 1.0

AsemanObject {

    readonly property bool syncing: storeReq.refreshing || actionsReq.refreshing || insertTimer.running || storeInterval.running

    Connections {
        target: GlobalSignals
        onSyncRequest: syncActionsInterval()
    }

    StoreActionsBulkRequest {
        id: storeReq
        onSuccessfull: {
            AsemanGlobals.lastSync = Tools.dateToString(new Date, "yyyy-MM-dd hh:mm:ss");
            actions.query("UPDATE actions SET synced = 1");
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
        storeInterval.restart();
    }

    function syncActions() {
        if (actionsReq.refreshing || storeReq.refreshing)
            return;

        actionsReq.networkManager.get(actionsReq);
    }

    function uploadUnsyncedActions() {
        var items = actions.query("SELECT poetId as poet_id, catId as category_id, poemId as poem_id, verseId as verse_id, " +
                                  "type, declined, value, extra, updatedAt as updated_at, updatedAt as inserted_at " +
                                  "FROM actions WHERE synced = 0", {});
        if (items.length == 0) {
            AsemanGlobals.lastSync = Tools.dateToString(new Date, "yyyy-MM-dd hh:mm:ss");
            return;
        }

        for (var i in items) {
            var it = items[i];
            it.updated_at = normalizeDate( Tools.dateFromSec(it.updated_at) );
            it.inserted_at = normalizeDate(new Date);
        }

        storeReq.actions = items;
        storeReq.networkManager.post(storeReq);
    }

    function normalizeDate(date) {
        var res = Tools.dateToString(date, "yyyy-MM-ddThh:mm:sst");
        if (res.length)
            res = res.slice(0, res.length-2) + ":" + res.slice(res.length-2);
        return res;
    }

    function unNormalizeDate(dateStr) {
        var res = dateStr.slice(0, dateStr.length-3) + dateStr.slice(dateStr.length-2);
        return Tools.datefromString(res, "yyyy-MM-ddThh:mm:sst");
    }
}
