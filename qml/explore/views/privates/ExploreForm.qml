import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.GraphicalEffects 2.0
import globals 1.0
import components 1.0

Item {
    id: homeForm
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias list: list
    property alias headerItem: headerItem

    Rectangle {
        id: listScene
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: Colors.deepBackground

        Rectangle {
            width: headerItem.width
            height: headerItem.height
            color: Colors.headerColor
        }

        ReloadItem {
            id: busyIndicator
            anchors.centerIn: parent
            viewItem: list
        }

        FlexiList {
            id: list
            topMargin: headerItem.height + spacing
            bottomMargin: 70 * Devices.density + Devices.navigationBarHeight
            anchors.fill: parent
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listScene.bottom
        anchors.top: headerItem.bottom
        anchors.bottomMargin: AsemanGlobals.viewMode == 2? 58 * Devices.density + Devices.navigationBarHeight : 0
        color: Colors.primary
        scrollArea: list
    }

    Header {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
    }

    Image {
        height: Devices.standardTitleBarHeight * 1.8
        width: height
        y: Devices.statusBarHeight + Devices.standardTitleBarHeight/2 - height/2
        anchors.horizontalCenter: headerItem.horizontalCenter
        source: Colors.lightHeader? "../icons/meikade.png" : "../icons/meikade-abstract.png"
        sourceSize.width: width * 1.2
        sourceSize.height: height * 1.2
        scale: 0.5
    }
}
