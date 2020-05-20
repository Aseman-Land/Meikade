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
    property alias offlineInstaller: offlineInstaller

    DataOfflineInstaller {
        id: offlineInstaller
        poetId: catsReq.poet_id
        catId: catsReq.parent_id
    }

    CatsRequest {
        id: catsReq
    }

    AsemanListModelSource {
        source: catsReq.response
        path: "result"
    }
}
