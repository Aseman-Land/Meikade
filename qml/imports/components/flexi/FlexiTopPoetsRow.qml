import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import globals 1.0
import models 1.0
import components 1.0
import "delegates"

FlexiGridRow {
    editable: true

    readonly property int count: TopPoetsHomeModel.count + 1

    list.model: TopPoetsHomeModel

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: TopPoetsHomeModel.count? 10 * Devices.density : 80 * Devices.density

        MLabel {
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.6
            font.pixelSize: 7 * Devices.fontDensity
            text: qsTr("To add items to shelf touch + button") + Translations.refresher
        }

        MButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 58 * Devices.density
            height: width
            radius: height/2
            highlighted: true
            icon: MaterialIcons.mdi_plus
            iconPixelSize: 12 * Devices.fontDensity
            onClicked: Viewport.controller.trigger("float:/favorites")
        }
    }
}
