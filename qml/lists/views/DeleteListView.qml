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
    cancelBtn.visible: false

    property alias confirmBtn: confirmBtn
    property alias rejectBtn: rejectBtn
    property alias bodyLabel: bodyLabel

    scene.height: Math.max(flickable.height, sceneColumn.height)

    headerLabel.text: qsTr("Delete List") + Translations.refresher

    ColumnLayout {
        id: sceneColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 15 * Devices.density
        spacing: 8 * Devices.density

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            spacing: 20 * Devices.density

            MLabel {
                id: bodyLabel
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 9 * Devices.fontDensity
                text: qsTr("Are you sure about delete this list?") + Translations.refresher
            }
        }

        MButton {
            id: rejectBtn
            Layout.fillWidth: true
            Layout.topMargin: 10 * Devices.density
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Cancel") + Translations.refresher
        }

        MButton {
            id: confirmBtn
            Layout.fillWidth: true
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Confirm") + Translations.refresher
            highlighted: true
        }
    }
}
