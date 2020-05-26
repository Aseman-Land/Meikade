import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {

    property alias refreshing: poemsReq.refreshing
    property alias poemId: poemsReq.poem_id

    enum PositionTypes {
        PositionRight = 0,
        PositionLeft = 1,
        PositionCenteredVerse1 = 2,
        PositionCenteredVerse2 = 3,
        PositionSingle = 4
    }

    DataOfflineVerses {
        id: offlineVerses
        poem_id: poemsReq.poem_id
        onPoem_idChanged: Tools.jsDelayCall(100, function() { result = getItems() })

        property variant result
    }

    PoemVersesRequest {
        id: poemsReq
    }

    AsemanListModelSource {
        source: poemsReq.response && Math.floor(poemsReq.status / 100) == 2? poemsReq.response : offlineVerses.result
        path: "result"

        ModelFormatHint {
            path: "text"
            method: function (arg) { return Tools.stringReplace(arg, "\\s+", " ", true); }
        }
    }
}
