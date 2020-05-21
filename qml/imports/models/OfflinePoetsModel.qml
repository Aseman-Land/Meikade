import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import Meikade 1.0
import requests 1.0
import queries 1.0

AsemanListModel {
    data: poetsReq.getItems()

    MeikadeOfflineItemGlobal {
        onOfflineInstalled: data = poetsReq.getItems()
    }

    DataOfflinePoets {
        id: poetsReq
    }
}
