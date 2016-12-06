import QtQuick 2.0
import QtQuick.Controls 2.0
import AsemanTools 1.0
import AsemanTools 1.1 as AT
import Meikade 1.0
import AsemanTools.Awesome 1.0
import QtQuick.Layouts 1.3

Rectangle {
    id: xml_page
    anchors.fill: parent
    clip: true

    readonly property string title: qsTr("Store")

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: "#3c994b"
        z: 2

        Item {
            anchors.fill: parent
            anchors.topMargin: View.statusBarHeight

            Text {
                id: configure_txt
                anchors.centerIn: parent
                height: headerHeight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#ffffff"
            }
        }

        TitleBarShadow {
            width: parent.width
            anchors.top: parent.bottom
        }
    }

    Indicator {
        id: list_indicator
        width: parent.width
        anchors.top: tabBar.bottom
        height: 100*Devices.density
        light: false
        modern: true
        indicatorSize: 20*Devices.density
        running: xml_model.refreshing
    }

    Text {
        anchors.horizontalCenter: list_indicator.horizontalCenter
        anchors.top: list_indicator.verticalCenter
        anchors.topMargin: 30*Devices.density
        font.pixelSize: 11*globalFontDensity*Devices.fontDensity
        font.family: AsemanApp.globalFont.family
        text: qsTr("Fetching poet lists...")
        color: "#333333"
        visible: list_indicator.running
    }

    Text {
        anchors.centerIn: list_indicator
        font.pixelSize: 11*globalFontDensity*Devices.fontDensity
        font.family: AsemanApp.globalFont.family
        text: qsTr("Can't connect to the server")
        color: "#333333"
        visible: xml_model.errors.length != 0 || (xml_model.count == 0 && !list_indicator.running)
    }

    AT.TabBar {
        id: tabBar
        anchors.top: header.bottom
        width: parent.width
        fontSize: 10*Devices.fontDensity
        currentIndex: view.currentIndex
        onCurrentIndexChanged: view.currentIndex = currentIndex
        model: [qsTr("New Poets"), qsTr("Updates"), qsTr("All"), qsTr("Classic"), qsTr("Modern")]
    }

    SwipeView {
        id: view
        width: parent.width
        anchors.top: tabBar.bottom
        anchors.bottom: parent.bottom
        currentIndex: 0

        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
        LayoutMirroring.childrenInherit: true

        XmlDownloaderPageItem { type: (1<<0) }
        XmlDownloaderPageItem { type: (1<<20) }
        XmlDownloaderPageItem { type: (1<<10)-1 }
        XmlDownloaderPageItem { type: (1<<1) }
        XmlDownloaderPageItem { type: (1<<2) }
    }

    PageIndicator {
        count: view.count
        currentIndex: view.currentIndex
        opacity: 0.8

        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
        LayoutMirroring.childrenInherit: true

        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Component.onCompleted: xml_model.refresh()
    ActivityAnalizer { object: xml_page }
}

