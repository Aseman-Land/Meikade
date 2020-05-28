import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {

    property alias refreshing: searchReq.refreshing
    property alias query: searchReq.query
    property alias poetId: searchReq.poet_id

    SearchVerseRequest {
        id: searchReq
    }

    AsemanListModelSource {
        source: searchReq.response
        path: "result"
    }
}

