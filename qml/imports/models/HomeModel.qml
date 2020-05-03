import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    cachePath: AsemanGlobals.cachePath + "/home.cache"

    HomeRequest {
        id: homeReq
    }

    AsemanListModelSource {
        source: homeReq.response
        path: "result"
    }
}
