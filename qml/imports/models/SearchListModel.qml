import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: lmodel

    readonly property bool refreshing: (searchReq.refreshing || timer.running) && timeoutTimer.running
    property alias query: searchReq.q

    onQueryChanged: timer.restart()

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

    SearchListRequest {
        id: searchReq
        onResponseChanged: {
            var res = new Array;
            try {
                var result = Tools.toVariantList(response.result);

                var r = {
                    "background": false,
                    "color": "transparent",
                    "section": "",
                    "type": "dynamic",
                    "heightRatio": 0.8,
                };

                var modelData = new Array;
                var counter = 0;
                result.forEach(function(u){
                    if (counter >= searchReq.limit)
                        return;

                    u["type"] = "normal";
                    u["heightRatio"] = 0.6;
                    u["subtitle"] = qsTr("%1 - %2 follower").arg(u.user.name).arg(u.follow + 1);
                    u["link"] = "popup:/lists/online?listId=" + u.id;
                    u["image"] = "";
                    u["details"] = Tools.jsonToVariant("{}");

                    modelData[modelData.length] = u;

                    counter++;
                });
                r["modelData"] = modelData;

                res[res.length] = Tools.toVariantMap(r);
            } catch(e) {
            }

            res.forEach(lmodel.append);
        }
    }
}

