import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import globals 1.0
import micros 1.0
import models 1.0

Rectangle {
    id: booksList
    width: Constants.width
    height: Constants.height
    color: Colors.deepBackground

    property alias gridView: listView
    property alias headerItem: headerItem
    property alias headerBtn: headerBtn

    signal clicked(string link)

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

        model: PoetModel {}
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        color: Colors.header

        HeaderMenuButton {
            id: headerBtn
            ratio: 1
        }

        ItemDelegate {
            width: height
            height: Devices.standardTitleBarHeight
            anchors.bottom: parent.bottom
            anchors.right: parent.right

            Label {
                anchors.centerIn: parent
                font.family: MaterialIcons.family
                font.pixelSize: 14 * Devices.fontDensity
                text: MaterialIcons.mdi_dots_vertical
                color: Colors.headerText
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        anchors.bottomMargin: Devices.standardTitleBarHeight
        color: Colors.primary
        scrollArea: listView
    }
}
