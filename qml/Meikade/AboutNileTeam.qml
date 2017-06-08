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
import "globals"

Rectangle {
    anchors.fill: parent
    color: "#dddddd"
    clip: true

    readonly property string title: qsTr("About Nile Group")

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: "#00A0E3"

        TitleBarShadow {
            width: header.width
            anchors.top: header.bottom
        }
    }

    AsemanFlickable {
        id: flickable
        anchors.top: header.bottom
        anchors.bottom: home_btn.top
        width: parent.width
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

                Item {width: 20; height: 20*Devices.density}

                Image {
                    width: 150*Devices.density
                    height: width
                    sourceSize: Qt.size(width,height)
                    source: "icons/nilegroup.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item {width: 2; height: 20*Devices.density}

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: -20*Devices.density
                    height: 50*Devices.density
                    color: "#cccccc"

                    Text {
                        anchors.centerIn: parent
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 12*globalFontDensity*Devices.fontDensity
                        font.bold: true
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        color: MeikadeGlobals.foregroundColor
                        text: qsTr("About Nile Group")
                    }
                }

                Item {width: 2; height: 20*Devices.density}

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: MeikadeGlobals.foregroundColor
                    text: qsTr("Nile is an Iranian software corporation that makes software for Desktop computers, Android, iOS, Mac, Windows Phone, Ubuntu Phone and ...\n"+
                               "Nile create Free and OpenSource projects.")

                    Component.onCompleted: {
                        width = flickable.width - 40*Devices.density
                    }
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
        width: 120*Devices.density
        normalColor: "#00A0E3"
        highlightColor: Qt.darker(normalColor)
        textColor: "#ffffff"
        radius: 4*Devices.density
        text: qsTr("Home Page")
        onClicked: Qt.openUrlExternally("http://nilegroup.org")
    }
}
