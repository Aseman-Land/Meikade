/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    Meikade is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Meikade is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import AsemanTools 1.0
import AsemanTools 1.1 as AT
import Meikade 1.0
import AsemanTools.Awesome 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.3
import "globals"

Rectangle {
    id: xml_page
    anchors.fill: parent
    clip: true
    color: MeikadeGlobals.backgroundColor

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
            visible: !Devices.isIOS
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
        running: xml_model.refreshing && (view.currentItem && view.currentItem.count == 0)
    }

    Text {
        anchors.horizontalCenter: list_indicator.horizontalCenter
        anchors.top: list_indicator.verticalCenter
        anchors.topMargin: 30*Devices.density
        font.pixelSize: 11*globalFontDensity*Devices.fontDensity
        font.family: AsemanApp.globalFont.family
        text: qsTr("Fetching poet lists...")
        color: MeikadeGlobals.foregroundColor
        visible: list_indicator.running
    }

    Text {
        anchors.centerIn: list_indicator
        font.pixelSize: 11*globalFontDensity*Devices.fontDensity
        font.family: AsemanApp.globalFont.family
        text: qsTr("Can't connect to the server")
        color: MeikadeGlobals.foregroundColor
        visible: xml_model.errors.length != 0 || (xml_model.count == 0 && !list_indicator.running)
    }

    AT.TabBar {
        id: tabBar
        anchors.top: header.bottom
        width: parent.width
        color: MeikadeGlobals.backgroundAlternativeColor
        textColor: MeikadeGlobals.foregroundColor
        fontSize: 10*Devices.fontDensity
        currentIndex: 0
        onCurrentIndexChanged: if(view) view.currentIndex = currentIndex
        model: [qsTr("Classic"), qsTr("In Between"), qsTr("Modern"), qsTr("Updates"), qsTr("Installed")]
    }

    SwipeView {
        id: view
        width: parent.width
        anchors.top: tabBar.bottom
        anchors.bottom: indicator.top
        currentIndex: 0
        onCurrentIndexChanged: tabBar.currentIndex = currentIndex
        interactive: false

        LayoutMirroring.enabled: View.reverseLayout
        LayoutMirroring.childrenInherit: true

        XmlDownloaderPageItem { type: (1<<1) }
        //From new poets to between
        XmlDownloaderPageItem { type: (1<<0) }
        XmlDownloaderPageItem { type: (1<<2) }
        //Put updates and new poets together
        XmlDownloaderPageItem { type: (1<<20) }
        XmlDownloaderPageItem { type: (1<<19) }
    }

    Rectangle {
        id: indicator
        anchors.bottom: parent.bottom
        width: parent.width
        height: 21*Devices.density
        color: MeikadeGlobals.backgroundAlternativeColor

        Column {
            anchors.fill: parent

            Rectangle {
                width: parent.width
                height: 1*Devices.density
                color: MeikadeGlobals.backgroundColor
            }

            PageIndicator {
                count: view.count
                currentIndex: view.currentIndex
                opacity: 0.8

                LayoutMirroring.enabled: View.reverseLayout
                LayoutMirroring.childrenInherit: true

                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Popup {
        id: removePopup
        x: parent.width/2 - width/2
        y: parent.height/2 - height/2
        modal: true
        focus: true

        property string poetName
        property var deleteCallback
        property var updateCallback

        onVisibleChanged: {
            if(visible) {
                BackHandler.pushHandler(removePopup, function(){removePopup.visible = false})
            } else {
                BackHandler.removeHandler(removePopup)
            }
        }

        ColumnLayout {

            Label{
                Layout.preferredWidth: 200*Devices.density
                color: MeikadeGlobals.foregroundColor
                font.pixelSize: 12*Devices.fontDensity
                horizontalAlignment: Label.AlignHCenter
                text: removePopup.poetName
            }

            Button {
                text: qsTr("Update")
                visible: removePopup.updateCallback != null
                onClicked: {
                    removePopup.updateCallback()
                    removePopup.close()
                }

                Material.foreground: Material.LightBlue
                Material.background: "transparent"
                Material.elevation: 0

                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Delete")
                onClicked: {
                    removePopup.deleteCallback()
                    removePopup.close()
                }

                Material.foreground: Material.Red
                Material.background: "transparent"
                Material.elevation: 0

                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }
        }
    }

    Component.onCompleted: xml_model.refresh()
    ActivityAnalizer { object: xml_page }
}
