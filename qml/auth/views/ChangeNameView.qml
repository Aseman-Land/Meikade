import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
import globals 1.0
import components 1.0
import "privates"

DrawerFrame {
    width: Constants.width
    height: Constants.height

    property alias confirmBtn: confirmBtn
    property alias nameField: nameField
    property alias text: nameField.text
    property alias description: contactName.text

    scene.height: Math.max(flickable.height, sceneColumn.height)

    headerLabel.text: qsTr("Change Name") + Translations.refresher

    Column {
        id: sceneColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 15 * Devices.density
        spacing: 4 * Devices.density

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20 * Devices.density
            spacing: 20 * Devices.density

            MLabel {
                id: contactName
                width: parent.width
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 9 * Devices.fontDensity
                text: qsTr("Please enter new name:") + Translations.refresher
            }
        }

        MTextField {
            id: nameField
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20 * Devices.density
            placeholderText: qsTr("Full Name") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
            horizontalAlignment: Text.AlignHCenter
            selectByMouse: true
            leftPadding: 34 * Devices.density
            rightPadding: 34 * Devices.density
            color: isValid || focus? Colors.foreground : "#a00"

            property bool isValid: length > 5

            MLabel {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 4 * Devices.density
                anchors.margins: 8 * Devices.density
                font.pixelSize: 12 * Devices.fontDensity
                font.family: MaterialIcons.family
                text: MaterialIcons.mdi_pencil
                color: Colors.accent
            }
        }

        MButton {
            id: confirmBtn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            enabled: nameField.isValid
            text: qsTr("Confirm") + Translations.refresher
            highlighted: true
        }
    }
}

