import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: lmodel

    readonly property bool refreshing: (searchReq.refreshing || timer.running) && timeoutTimer.running
    property alias query: searchReq._query
    property alias poets: searchReq.poets

    onQueryChanged: timer.restart()
    onPoetsChanged: timer.restart()

    function more() {
        searchReq._offset = count;
        searchReq.refresh();
        timeoutTimer.restart();
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

    SearchVerseRequest {
        id: searchReq
        onResponseChanged: {
            var res = new Array;
            try {
                for (var i in response.result) {
                    var u = response.result[i];
                    u["link"] = "page:/poet?id=" + u.poet.id + "&poemId=" + u.poem.id

                    res[res.length] = u;
                }
            } catch(e) {
            }

            res.forEach(lmodel.append);
        }
    }
}

