import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import globals 1.0
import components 1.0
import models 1.0

Item {
    id: poetsList
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias tabBarRepeater: tabBarRepeater

    property alias tabBar: tabBar
    property alias gridView: gridView
    property alias headerItem: headerItem
    property alias headerBtn: headerBtn
    property alias busyIndicator: busyIndicator

    signal clicked(string link)

    Rectangle {
        anchors.fill: parent
        color: Colors.deepBackground
    }

    ReloadItem {
        id: busyIndicator
        anchors.centerIn: parent
        viewItem: gridView
    }

    FlexiList {
        id: gridView
        anchors.top: tabBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        color: Colors.headerColor
        light: !Colors.lightHeader
        text: qsTr("All Poets") + Translations.refresher
        titleFontSize: 10 * Devices.fontDensity
        shadow: Devices.isAndroid

        HeaderBackButton {
            id: headerBtn
        }
    }

    Rectangle {
        anchors.fill: tabBar
        color: Colors.deepBackground
    }

    TabBar {
        id: tabBar
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        LayoutMirroring.enabled: false;
        LayoutMirroring.childrenInherit: true

        Repeater {
            id: tabBarRepeater
            TabButton {
                font.pixelSize: 9 * Devices.fontDensity
                text: GTranslations.localeName == "fa"? model.name : model.name_en
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: gridView.bottom
        anchors.top: gridView.top
        anchors.bottomMargin: Devices.standardTitleBarHeight
        color: Colors.primary
        scrollArea: gridView
    }
}
