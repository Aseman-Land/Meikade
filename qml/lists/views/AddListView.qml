import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Layouts 1.3
import globals 1.0
import components 1.0

DrawerFrame {
    width: Constants.width
    height: Constants.height

    property alias confirmBtn: confirmBtn
    property alias nameField: nameField
    property bool renameMode

    scene.height: Math.max(flickable.height, sceneColumn.height)

    headerLabel.text: renameMode? qsTr("Rename List") : qsTr("Add List") + Translations.refresher

    ColumnLayout {
        id: sceneColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 15 * Devices.density
        spacing: 10 * Devices.density

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            spacing: 20 * Devices.density

            MLabel {
                id: contactName
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 9 * Devices.fontDensity
                text: qsTr("Please enter list name:") + Translations.refresher
            }
        }

        MTextField {
            id: nameField
            Layout.fillWidth: true
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            placeholderText: qsTr("List Name") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
            horizontalAlignment: Text.AlignHCenter
            selectByMouse: true
            leftPadding: 34 * Devices.density
            rightPadding: 34 * Devices.density

            property bool isValid: text.length > 0 || preeditText.length > 0

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
            Layout.fillWidth: true
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            enabled: nameField.isValid
            text: renameMode? qsTr("Rename") : qsTr("Add") + Translations.refresher
            highlighted: true
        }
    }
}
