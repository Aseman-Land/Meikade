import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {

    property alias refreshing: catsReq.refreshing
    property alias poetId: catsReq.poet_id
    property alias parentId: catsReq.parent_id

    CatsRequest {
        id: catsReq
        _debug: true
    }

    AsemanListModelSource {
        source: catsReq.response
        path: "result"
    }
}
