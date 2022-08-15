import QtQuick 2.12
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import models 1.0
import "delegates"

FlexiGridRow {

    readonly property int count: TopPoetsHomeModel.count + 1

    list.model: TopPoetsHomeModel

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: TopPoetsHomeModel.count? 0 : 60 * Devices.density

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Manage Shelf") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
//            highlighted: isAndroidStyle
            Material.elevation: 0
            Material.background: Colors.lightBackground
            Material.foreground: Colors.accent

            Connections {
                onClicked: Viewport.controller.trigger("float:/favorites")
            }
        }
    }
}
