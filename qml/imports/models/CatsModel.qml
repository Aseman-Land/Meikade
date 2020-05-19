import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: model

    property alias refreshing: catsReq.refreshing
    property alias poetId: catsReq.poet_id
    property alias parentId: catsReq.parent_id
    property alias offline: offline.state

    DataOffline {
        id: offline
        poet_id: catsReq.poet_id
        cat_id: catsReq.parent_id
        onStateChanged: console.debug(state, model.count)
        Component.onCompleted: fetch()
    }

    CatsRequest {
        id: catsReq
    }

    AsemanListModelSource {
        source: catsReq.response
        path: "result"
    }
}
