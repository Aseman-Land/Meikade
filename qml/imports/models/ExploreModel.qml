import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    property alias refreshing: homeReq.refreshing

    ExploreRequest {
        id: homeReq
    }

    AsemanListModelSource {
        source: homeReq.response
        path: "result"
    }

    function refresh() { homeReq.refresh() }
}
