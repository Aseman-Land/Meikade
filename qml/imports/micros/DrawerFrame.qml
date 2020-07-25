import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0

Item {
    width: Constants.width
    height: Constants.height

    default property alias sceneData: scene.data
    property alias cancelBtn: cancelBtn
    property alias headerLabel: headerLabel
    property alias scene: scene
    property alias flickable: flickable


    Rectangle {
        anchors.fill: parent
        color: Colors.background
        opacity: 0.5
    }

    AsemanFlickable {
        id: flickable
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height
        clip: true

        EscapeItem {
            id: scene
            width: flickable.width
            height: flickable.height
        }
    }

    Item {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: Devices.standardTitleBarHeight

        Separator {}

        Label {
            id: headerLabel
            anchors.centerIn: parent
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Frame") + Translations.refresher
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: cancelBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Cancel") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                Material.accent: Qt.darker(Colors.header, 1.3)
                Material.theme: Material.Dark
                IOSStyle.accent: Qt.darker(Colors.header, 1.3)
                IOSStyle.theme: IOSStyle.Dark
                Material.elevation: 0
            }
        }
    }
}
