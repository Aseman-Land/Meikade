/*
    Copyright (C) 2014 Aseman Labs
    http://labs.aseman.org

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
    color: "#333333"

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: "#FF7340"

        Button{
            id: back_btn
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: View.statusBarHeight
            height: headerHeight
            radius: 0
            normalColor: "#00000000"
            highlightColor: "#88666666"
            textColor: "#ffffff"
            icon: "icons/back_light_64.png"
            iconHeight: 16*Devices.density
            fontSize: 11*Devices.fontDensity
            textFont.bold: false
            visible: backButton
            onClicked: {
                AsemanApp.back()
                Devices.hideKeyboard()
            }
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: header.height
        contentWidth: column.width
        contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick
        clip: true

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

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 10*Devices.fontDensity
                    font.bold: true
                    text: qsTr("Meikade is a free and opensource application by Nile Team")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#ffffff"
                }

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 9*Devices.fontDensity
                    text: qsTr("Meikade is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#ffffff"
                }

                Item {width: 20; height: 30*Devices.density}

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 10*Devices.fontDensity
                    font.bold: true
                    text: qsTr("Meikade Members:")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#ffffff"
                }

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 9*Devices.fontDensity
                    text: qsTr(" - Bardia Daneshvar (Team's Leader and Developer)\n"+
                               " - AmirHosein Mousavi (Designer and Idea Processing)\n"+
                               " - Pourya Daneshvar (Designer)\n"+
                               " - Hasan Noruzi (Idea Processing)")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#ffffff"
                }
            }
        }
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 20*Devices.density
        anchors.bottomMargin: View.navigationBarHeight + 10*Devices.density
        font.family: AsemanApp.globalFont.family
        font.pixelSize: 9*Devices.fontDensity
        text: "v2.0.0"
        wrapMode: Text.WordWrap
        color: "#ffffff"
        horizontalAlignment: Text.AlignRight
    }
}
