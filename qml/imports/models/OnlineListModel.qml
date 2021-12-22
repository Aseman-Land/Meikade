import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    id: dis

    property alias listId: listReq._list_id
    property alias refreshing: listReq.refreshing

    property bool flatList: false
    property string listColor

    onFlatListChanged: reload()

    ListRequest {
        id: listReq
        onSuccessfull: {
            dis.clear();
            dis.reload();
        }
    }

    HashObject {
        id: hash
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
    }
}
