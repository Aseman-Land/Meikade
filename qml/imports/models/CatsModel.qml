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

    readonly property int realCount: {
        var count = 0;
        if (model.count == 0)
            return count;

        try {
            for (var i in data)
                count += data[i].modelData.length;
        } catch (e) {
            count = 0;
        }
        return count;
    }

    DataOfflineInstaller {
        id: offlineInstaller
        poetId: catsReq.poet_id
        catId: catsReq.parent_id
    }

    DataOfflineCats {
        id: offlineCats

        Component.onCompleted: load(0, catsReq.limit);

        function load(offset, limit) {
            if (realCount > offset || !offlineInstaller.installed)
                return;

            var items = new Array;
            var poemsCount = 0;
            var catsCount = 0;

            var analize = function(data, poemQuery) {
                for (var i in data)
                {
                    var d = data[i];
                    var item = {
                        "color": "",
                        "details": null,
                        "heightRatio": 0.6,
                        "image": "",
                        "link": "page:/poet?id=" + d.poet_id + (poemQuery? "&poemId=" : "&catId=") + d.id,
                        "subtitle": d.poemsCount + " poems",
                        "title": d.text,
                        "type": "fullback",
                        "details": {
                            "first_verse": d.first_verse
                        }
                    };

                    items[items.length] = item;
                }

                if (poemQuery)
                    poemsCount = items.length;
                else
                    catsCount = items.length;
            }

            analize( query("SELECT cat.id, cat.poet_id, cat.text, COUNT(poem.id) as poemsCount " +
                           "FROM cat LEFT OUTER JOIN poem ON cat.id = poem.cat_id " +
                           "WHERE cat.poet_id = :poet_id AND cat.parent_id = :cat_id " +
                           " GROUP BY cat.id LIMIT :limit OFFSET :offset",
                           {"poet_id": catsReq.poet_id, "cat_id": catsReq.parent_id, "offset": offset, "limit": limit}), false);

            analize( query("SELECT id, " + catsReq.poet_id + " as poet_id, title as text, 0 as poemsCount, verse.text as first_verse " +
                           "FROM poem LEFT OUTER JOIN verse ON poem.id = verse.poem_id AND vorder = 1 " +
                           "WHERE cat_id = :cat_id GROUP BY poem.id LIMIT :limit OFFSET :offset",
                           {"cat_id": catsReq.parent_id, "offset": offset, "limit": limit}), true);


            var resItem = {
                "background": false,
                "color": "transparent",
                "section": "",
                "type": catsReq.parent_id == 0? "grid" : "column",
                "modelData": items,
                "offlineResult": true,
                "offset": offset
            };

            var length = resItem.modelData.length;
            for (var j=0; j<length; j++) {
                var d = resItem.modelData[j];
                d["moreHint"] = (j === (length - 20));
            }

            putResult([resItem]);
        }
    }

    CatsRequest {
        id: catsReq
        onResponseChanged: {
            var result
            try {
                result = response.result;
                var offset_dynamic = offset;
                for (var i in result) {
                    var resUnit = result[i];
                    resUnit["offlineResult"] = false;
                    resUnit["offset"] = offset_dynamic;

                    var length = resUnit.modelData.length;
                    offset_dynamic += length;

                    for (var j=0; j<length; j++) {
                        var d = resUnit.modelData[j];
                        d["moreHint"] = (j === (length - 20) && (i*1 === result.length-1));
                    }
                }

                putResult(result);
            } catch (e) {
            }
        }
    }

    Timer {
        id: moreBlockTimer
        interval: 1000
        repeat: false
    }

    function putResult(result) {
        moreBlockTimer.restart()

        var ofs = result[0].offset;
        if (ofs == 0)
            clear();

        var idx = -1;
        for (var j=0; j<model.count; j++) {
            var modelData = model.get(j)
            if (modelData.offset == ofs)
                idx = j;
            if (idx >= 0)
            {
                model.remove(idx);
                j--;
            }
        }

        result.forEach(model.append);
    }

    function more() {
        if (moreBlockTimer.running)
            return;

        var offset = realCount;

        offlineCats.load(offset, catsReq.limit);

        catsReq.offset = offset;
        catsReq.networkManager.get(catsReq);
    }
}
