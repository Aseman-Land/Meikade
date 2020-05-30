import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: lmodel

    readonly property bool refreshing: searchReq.refreshing || timer.running
    property alias query: searchReq.query
    property alias poetId: searchReq.poet_id

    onQueryChanged: timer.restart()
    onPoetIdChanged: timer.restart()

    Timer {
        id: timer
        interval: 300
        repeat: false
        onTriggered: {
            searchQuery.getItems(query, function(list){
                console.debug(Tools.variantToJson(list));
            })
            searchReq.refresh();
        }
    }

    SearchVerseQuery {
        id: searchQuery
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

            lmodel.data = res;
        }
    }
}

