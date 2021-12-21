import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    id: dis

    property alias listId: listReq._list_id
    property alias refreshing: listReq.refreshing

    ListRequest {
        id: listReq
        onSuccessfull: {
            var data = new Array;
            var list = response.result.items;
            for (var i in list) {
                try {
                    var item = Tools.toVariantMap(list[i]);
                    item["isVerse"] = (item.verse_id != 0);
                    if (item.poet_id == 0) {
                        continue;
                    }

                    var extraJson = Tools.toVariantMap(item.extra);
                    extraJson["poet"] = extraJson.subtitle;
                    extraJson["type"] = "normal";

                    for (var j in extraJson)
                        if (j != "extra")
                            item[j] = extraJson[j];

                    data[data.length] = item;
                } catch (e) {console.debug(e)}
            }

            dis.data = data;
        }
    }
}
