import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import globals 1.0

AddListView {
    id: home
    width: parent.width
    height: 300 * Devices.density

    cancelBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: updateReq.networkManager.post(updateReq)
}
