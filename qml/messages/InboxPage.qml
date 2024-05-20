import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import models 1.0
import requests 1.0
import "views"

InboxView {
    id: dis
    closeBtn.onClicked: ViewportType.open = false
    inboxModel: RequestsModel
    Component.onCompleted: RequestsModel.refresh()
}


