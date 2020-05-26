import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {

    property alias typeId: poetsReq.type_id
    property alias refreshing: poetsReq.refreshing

    PoetsRequest {
        id: poetsReq
    }

    AsemanListModelSource {
        source: poetsReq.response
        path: "result"
    }
}
