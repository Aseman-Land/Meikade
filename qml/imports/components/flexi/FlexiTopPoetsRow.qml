import QtQuick 2.12
import QtQuick.Controls 2.9
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import models 1.0
import "delegates"

FlexiGridRow {
    editable: true

    readonly property int count: TopPoetsHomeModel.count + 1

    list.model: TopPoetsHomeModel

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: TopPoetsHomeModel.count? 10 * Devices.density : 80 * Devices.density

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: 0.6
            font.pixelSize: 7 * Devices.fontDensity
            text: qsTr("To add items to shelf touch + button") + Translations.refresher
        }

        RoundButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 58 * Devices.density
            height: width
            radius: height/2
            Material.elevation: 0
            Material.accent: Colors.primary
            IOSStyle.accent: Colors.primary
            highlighted: true
            onClicked: Viewport.controller.trigger("float:/favorites")

            Label {
                anchors.centerIn: parent
                font.family: MaterialIcons.family
                font.pixelSize: 12 * Devices.fontDensity
                text: MaterialIcons.mdi_plus
                color: "#fff"
            }
        }
    }
}
