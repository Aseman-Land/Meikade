import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.3
import globals 1.0
import components 1.0
import "privates"

MPage {
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

    MBusyIndicator {
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

        MProgressBar {
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

            MLabel {
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

            HeaderBackButton {
                id: closeBtn
            }
        }
    }
}

