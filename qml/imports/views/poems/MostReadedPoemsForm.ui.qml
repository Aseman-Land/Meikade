import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0
import models 1.0

Item {
    id: booksList
    width: Constants.width
    height: Constants.height

    property alias listView: listView
    property alias headerItem: headerItem
    property alias closeBtn: closeBtn
    property alias tabBar: tabBar

    property real downloadProgress: 0.3

    signal navigationClicked(string link, int index)

    Rectangle {
        anchors.fill: parent
        color: Colors.deepBackground
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: listView.model && listView.model.refreshing !== undefined && listView.model.refreshing && listView.count == 0
    }

    AsemanListView {
        id: listView
        anchors.top: tabBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        topMargin: 4 * Devices.density
        bottomMargin: 4 * Devices.density
    }

    Rectangle {
        anchors.fill: tabBar
        color: Colors.deepBackground
    }

    TabBar {
        id: tabBar
        anchors.top: headerItem.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        Material.accent: Material.primary

        TabButton {
            text: qsTr("Poets") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
        }
        TabButton {
            text: qsTr("Books") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
        }
        TabButton {
            text: qsTr("Poems") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
        }
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Most Recents") + Translations.refresher
        color: Colors.header
        shadow: Devices.isAndroid

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14 * Devices.density
            anchors.rightMargin: 2 * Devices.density
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: closeBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Close") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.accent: Qt.darker(Colors.primary, 1.3)
                Material.accent: Qt.darker(Colors.primary, 1.3)
                Material.theme: Material.Dark
                Material.elevation: 0
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        color: Colors.primary
        scrollArea: listView
    }
}
