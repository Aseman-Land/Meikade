import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: lmodel

    readonly property bool refreshing: (searchReq.refreshing || timer.running) && timeoutTimer.running
    property alias query: searchReq.query
    property alias typeId: searchReq.type_id

    onQueryChanged: timer.restart()
    onTypeIdChanged: timer.restart()

    function more() {
        searchReq.offset = count;
        searchReq.refresh();
    }

    Timer {
        id: timer
        interval: 1000
        repeat: false
        onTriggered: {
            timeoutTimer.restart();

            lmodel.clear();
            searchReq.refresh();
        }
    }

    Timer {
        id: timeoutTimer
        interval: 5000
        repeat: false
    }

    SearchPoetsRequest {
        id: searchReq
        onResponseChanged: {
            var res = new Array;
            try {
                var result = response.result;
                result.forEach(function(r){
                    r["type"] = "dynamic";

                    var modelData = new Array;
                    r.modelData.forEach(function(u){
                        u["type"] = "normal";
                        u["heightRatio"] = 1;

                        modelData[modelData.length] = u;
                    });

                    res[res.length] = Tools.toVariantMap(r);
                })
            } catch(e) {
            }

            res.forEach(lmodel.append);
        }
    }
}

