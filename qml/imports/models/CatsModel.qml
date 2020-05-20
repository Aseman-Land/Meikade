import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: model

    readonly property bool refreshing: catsReq.refreshing && !offlineCats.result
    property alias poetId: catsReq.poet_id
    property alias parentId: catsReq.parent_id
    property alias offlineInstaller: offlineInstaller

    DataOfflineInstaller {
        id: offlineInstaller
        poetId: catsReq.poet_id
        catId: catsReq.parent_id
    }

    DataOfflineCats {
        id: offlineCats

        property variant result

        Component.onCompleted: {
            if (model.count || !offlineInstaller.installed)
                return;

            var data = query("SELECT cat.id, cat.poet_id, cat.text, COUNT(poem.id) as poemsCount " +
                             "FROM cat LEFT OUTER JOIN poem ON cat.id = poem.cat_id " +
                             "WHERE cat.poet_id = :poet_id AND (:cat_id < 1 OR cat.id = :cat_id) " +
                             " GROUP BY cat.id",
                             {"poet_id": catsReq.poet_id, "cat_id": catsReq.parent_id});
            var items = new Array;
            for (var i in data)
            {
                var d = data[i];
                var item = {
                    "color": "",
                    "details": null,
                    "heightRatio": 0.6,
                    "image": "",
                    "link": "page:/poet?id=" + d.poet_id + "&catId=" + d.id,
                    "subtitle": d.poemsCount + " poems",
                    "title": d.text,
                    "type": "fullback"
                };

                items[items.length] = item;
            }

            var resItem = {
                "background": false,
                "color": "transparent",
                "section": "",
                "type": "grid",
                "modelData": items
            };

            console.debug(Tools.variantToJson(resItem))
            result = [resItem];
        }
    }

    CatsRequest {
        id: catsReq
    }

    AsemanListModelSource {
        source: catsReq.response
        path: "result"
    }
    AsemanListModelSource {
        source: catsReq.response? null : offlineCats.result
    }

    function more() {

    }
}
