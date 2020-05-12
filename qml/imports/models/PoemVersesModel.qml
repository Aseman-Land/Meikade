import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
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

    PoemVersesRequest {
        id: poemsReq
    }

    AsemanListModelSource {
        source: poemsReq.response
        path: "result"
    }
}
