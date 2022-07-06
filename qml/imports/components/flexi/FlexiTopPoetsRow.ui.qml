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

    list.model: TopPoetsHomeModel

    Button {
        anchors.verticalCenterOffset: 60 * Devices.density
        anchors.centerIn: parent
        visible: TopPoetsHomeModel.count == 0
        text: qsTr("Add Poets") + Translations.refresher
        font.pixelSize: 9 * Devices.fontDensity
//        highlighted: isAndroidStyle
        Material.elevation: 0
        Material.background: Colors.lightBackground
        Material.foreground: Colors.accent

        Connections {
            onClicked: Viewport.controller.trigger("float:/favorites")
        }
    }
}
