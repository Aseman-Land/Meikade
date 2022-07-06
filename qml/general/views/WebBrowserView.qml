import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import globals 1.0
import "privates"

Page {
    width: Constants.width
    height: Constants.height

    property alias scene: scene
    property alias progressBar: progressBar
    property alias busyIndicator: busyIndicator
    property alias closeBtn: closeBtn
    property alias webTitle: webTitle

    Rectangle {
        anchors.fill: parent
        color: Colors.background
    }

    Item {
        id: scene
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
    }

    BusyIndicator {
        id: busyIndicator
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        anchors.centerIn: parent
        running: false
    }

    Rectangle {
        id: headerItem
        color: Colors.lightBackground
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Devices.standardTitleBarHeight + Devices.statusBarHeight

        ProgressBar {
            id: progressBar
            indeterminate: true
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            visible: false
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14 * Devices.density
            anchors.rightMargin: 2 * Devices.density
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            Label {
                id: webTitle
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12 * Devices.fontDensity
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
                text: qsTr("Loading") + Translations.refresher
            }

            RoundButton {
                id: closeBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Close") + Translations.refresher
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.foreground: Colors.foreground
                IOSStyle.background: Colors.deepBackground
                Material.foreground: Colors.foreground
                Material.background: Colors.deepBackground
                Material.theme: Material.Dark
                Material.elevation: 0
            }
        }
    }
}

