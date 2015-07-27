/*
    Copyright (C) 2015 Nile Group
    http://nilegroup.org

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

Rectangle {
    id: about
    width: 100
    height: 62
    color: "#dddddd"

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: "#A80807"

        Button{
            id: back_btn
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: View.statusBarHeight
            height: headerHeight
            radius: 0
            normalColor: "#00000000"
            highlightColor: "#88666666"
            textColor: "#333333"
            icon: "icons/back_light_64.png"
            iconHeight: 16*Devices.density
            fontSize: 11*globalFontDensity*Devices.fontDensity
            textFont.bold: false
            visible: backButton
            onClicked: {
                AsemanApp.back()
                Devices.hideKeyboard()
            }
        }

        TitleBarShadow {
            width: header.width
            anchors.top: header.bottom
        }
    }

    Flickable {
        id: flickable
        anchors.top: header.bottom
        anchors.bottom: home_btn.top
        width: parent.width
        contentWidth: column.width
        contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        rebound: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 0
            }
        }

        Item {
            id: main_item
            width: flickable.width
            height: column.height>flickable.height? column.height : flickable.height

            Column {
                id: column
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20*Devices.density
                anchors.verticalCenter: parent.verticalCenter

                Item {width: 20; height: 20*Devices.density}

                Image {
                    width: 128*Devices.density
                    height: width
                    sourceSize: Qt.size(width,height)
                    source: "icons/meikade.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item {width: 2; height: 20*Devices.density}

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                    font.bold: true
                    text: qsTr("Meikade is a free and opensource application by Nile Team")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#333333"
                }

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    text: qsTr("Meikade is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#333333"
                }

                Item {width: 20; height: 30*Devices.density}

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                    font.bold: true
                    text: qsTr("Meikade Members:")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#333333"
                }

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    text: qsTr(" - Bardia Daneshvar (Project Leader and Developer)\n"+
                               " - AmirHosein Mousavi (Designer and Idea Processing)\n"+
                               " - Pourya Daneshvar (Designer)\n"+
                               " - Hasan Noruzi (Idea Processing)")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#333333"
                }
            }
        }
    }

    Button {
        id: home_btn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: View.navigationBarHeight + 10*Devices.density
        anchors.horizontalCenter: parent.horizontalCenter
        height: 40*Devices.density
        width: 150*Devices.density
        normalColor: "#A80807"
        highlightColor: Qt.darker(normalColor)
        textColor: "#ffffff"
        radius: 4*Devices.density
        text: qsTr("Meikade Github")
        onClicked: Qt.openUrlExternally("https://github.com/NileGroup/Meikade")
    }

    Text {
        id: version
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 20*Devices.density
        anchors.bottomMargin: View.navigationBarHeight + 10*Devices.density
        font.family: AsemanApp.globalFont.family
        font.pixelSize: 9*globalFontDensity*Devices.fontDensity
        text: AsemanApp.applicationVersion
        wrapMode: Text.WordWrap
        color: "#333333"
        horizontalAlignment: Text.AlignRight
    }
}
