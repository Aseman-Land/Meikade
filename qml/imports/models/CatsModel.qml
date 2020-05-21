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
        poet_id: catsReq.poet_id
        parent_id: catsReq.parent_id

        Component.onCompleted: load(0, catsReq.limit);

        function load(offset, limit) {
            if (realCount > offset || !offlineInstaller.installed)
                return;

            var resItem = getItems(offset, limit)
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
