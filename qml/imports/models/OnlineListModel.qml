import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0
import queries 1.0

AsemanListModel {
    id: dis

    property int localId
    property alias listId: listReq._list_id
    property alias refreshing: listReq.refreshing

    property bool flatList: false
    property string listColor

    onFlatListChanged: reload()
    onListIdChanged: Tools.jsDelayCall(10, function(){ dis.localId = checkFollowed() });

    signal loadedSuccessfully()

    ListRequest {
        id: listReq
        onSuccessfull: {
            dis.clear();
            dis.reload();
        }
    }

    UserActions {
        id: listsQuery
    }
    UserActions {
        id: createAction
        poemId: 0
        poetId: 0
        declined: 0
    }

    UserActions {
        id: deleteAction
        type: localId
    }

    HashObject {
        id: hash
    }

    function checkFollowed() {
        var lists = listsQuery.getFullLists();
        for (var i in lists) {
            var item = Tools.toVariantMap(lists[i]);
            var extra = Tools.jsonToVariant(item.extra);
            if (extra.referenceId == dis.listId)
                return item.type;
        }
        return 0;
    }

    HashObject {
        id: followTempList
    }

    function follow(title, provider) {
        var listId = (localId? localId : createAction.generateNewListId());

        followTempList.clear();
        if (localId) {
            var all = listsQuery.select("", "type = :type AND poetId > 0 AND declined = 0", "ORDER BY updatedAt", {type: listId});
            all.forEach(function(a){
                followTempList.insert(a.poetId + "-" + a.catId + "-" + a.poemId + "-" + a.verseId, a);
            });
        }

        var extra = {
            "public": false,
            "referenceId": dis.listId,
            "listColor": dis.listColor,
            "flatList": dis.flatList,
            "provider": provider,
        };

        createAction.type = listId;
        createAction.value = title;
        createAction.extra = Tools.variantToJson(extra, true);
        createAction.pushAction();

        var list = listReq.response.result.items;
        for (var i in list) {
            try {
                var item = Tools.toVariantMap(list[i]);
                if (item.poet_id == 0)
                    continue;

                listsQuery.poetId = item.poet_id;
                listsQuery.catId = item.category_id;
                listsQuery.poemId = item.poem_id;
                listsQuery.verseId = item.verse_id;
                listsQuery.declined = 0;
                listsQuery.type = listId;
                listsQuery.extra = Tools.variantToJson(item.extra, true);
                listsQuery.pushAction()

                if (localId)
                    followTempList.remove(item.poet_id + "-" + item.category_id + "-" + item.poem_id + "-" + item.verse_id);
            } catch (e) {console.debug(e)}
        }

        if (localId) {
            all = followTempList.keys;
            for (var k in all) {
                var it = followTempList.value(all[k]);
                listsQuery.poetId = it.poetId;
                listsQuery.catId = it.catId;
                listsQuery.poemId = it.poemId;
                listsQuery.verseId = it.verseId;
                listsQuery.declined = 1;
                listsQuery.type = listId;
                listsQuery.extra = it.extra;
                listsQuery.pushAction();
            }
        }

        if (localId == 0) {
            GlobalSignals.snackbarRequest( qsTr("\"%1\" followed").arg(title) );
        }
        GlobalSignals.listsRefreshed();
        localId = listId;
    }

    function unfollow(title, provider) {
        deleteAction.declined = 1;
        deleteAction.pushAction();
        localId = 0;

        GlobalSignals.snackbarRequest( qsTr("\"%1\" unfollowed").arg(title) );
        GlobalSignals.listsRefreshed();
    }

    function reload() {
        hash.clear();
        if (!listReq.response)
            return;

        var data = new Array;
        var list = listReq.response.result.items;
        for (var i in list) {
            try {
                var item = Tools.toVariantMap(list[i]);
                item["isVerse"] = (item.verse_id != 0);
                if (item.poet_id == 0) {
                    if (item.extra.flatList != flatList && dis.count == 0) {
                        flatList = item.extra.flatList;
                        listColor = item.extra.listColor;
                        return;
                    }
                    continue;
                }

                var extraJson = Tools.toVariantMap(item.extra);
                extraJson["poet"] = extraJson.subtitle;
                extraJson["type"] = "normal";

                for (var j in extraJson)
                    if (j != "extra")
                        item[j] = extraJson[j];

                if (!flatList) {
                    var l;
                    if (hash.contains(item.poet_id)) {
                        l = hash.value(item.poet_id);
                        hash.remove(item.poet_id);
                    } else {
                        l = new Array;
                    }
                    l[l.length] = Tools.toVariantMap(item);
                    hash.insert(item.poet_id, l);
                    if (l.length > 1)
                        continue;
                }

                data[data.length] = item;
            } catch (e) {console.debug(e)}
        }

        for (var i in data) {
            var d = data[i];
            if (hash.contains(d.poet_id))
                d["childs"] = hash.value(d.poet_id);
            else
                d["childs"] = new Array;
            data[i] = d;
        }

        dis.data = data;
        dis.loadedSuccessfully();
    }
}
