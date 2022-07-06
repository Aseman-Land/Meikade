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
    property bool smart: true

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

    UserActions {
        id: userActions
    }

    SearchVerseRequest {
        id: searchReq
        _smart: lmodel.smart? "true" : "false"
        onResponseChanged: {
            if (_offset == 0)
                lmodel.clear();

            var res = new Array;
            try {
                for (var i in response.result) {
                    var u = response.result[i];
                    u["link"] = "page:/poet?id=" + u.poet.id + "&poemId=" + u.poem.id

                    userActions.poetId = u.poet.id;
                    userActions.poemId = u.poem.id;
                    var attrs = userActions.getPoemAttributes();

                    var verses = new Array;
                    u.verses.forEach( function(v){
                        try { v.favorited = attrs[v.vorder][UserActions.TypeFavorite]; } catch (ve) { v.favorited = false; }
                        if (!v.favorited) v.favorited = false;

                        try { v.hasNote = attrs[v.vorder][UserActions.TypeNote]; } catch (ne) { v.hasNote = false; }
                        if (!v.hasNote) v.hasNote = false;

                        try { v.hasList = attrs[v.vorder][UserActions.TypeItemListsStart]; } catch (le) { v.hasList = false; }
                        if (!v.hasList) v.hasList = false;

                        verses[verses.length] = Tools.toVariantMap(v);
                    });
                    u.verses = verses;

                    res[res.length] = u;
                }
            } catch(e) {
            }

            res.forEach(lmodel.append);
        }
    }
}

