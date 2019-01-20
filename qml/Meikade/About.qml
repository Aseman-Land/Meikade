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
import QtQuick.Controls 2.1 as QtControls
import QtQuick.Controls.Material 2.1
import AsemanQml.Base 2.0
import "globals"

Rectangle {
    id: about
    anchors.fill: parent
    clip: true
    color: MeikadeGlobals.backgroundColor

    readonly property string title: qsTr("About")

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: MeikadeGlobals.masterColor

        TitleBarShadow {
            width: header.width
            visible: !MeikadeGlobals.iosStyle
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
                    text: qsTr("Meikade is a free and opensource application by Aseman Team")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: MeikadeGlobals.foregroundColor
                }

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    text: qsTr("Meikade is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: MeikadeGlobals.foregroundColor
                }

                Item {width: 20; height: 30*Devices.density}

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                    font.bold: true
                    text: qsTr("Meikade Members:")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: MeikadeGlobals.foregroundColor
                }

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    text: qsTr(" - Bardia Daneshvar (Project Founder, Project Architect and Developer)\n"+
                               " - AmirHosein Mousavi (Director of Public Relations and Developer)\n"+
                               " - Amin Hatami (Logo Designer)")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: MeikadeGlobals.foregroundColor
                }

                Item {width: 20; height: 30*Devices.density}

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                    font.bold: true
                    text: qsTr("Thanks to:")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: MeikadeGlobals.foregroundColor
                }

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    text: qsTr(" - Pourya Daneshvar\n"+
                               " - Arman Farajollahifar\n"+
                               " - Hasan Noruzi\n"+
                               " - Hootan Baraary\n"+
                               " - Mansooreh Zamani")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: MeikadeGlobals.foregroundColor
                }
            }
        }
    }

    QtControls.Button {
        id: home_btn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: View.navigationBarHeight + 10*Devices.density
        anchors.horizontalCenter: parent.horizontalCenter
        width: 150*Devices.density
        text: qsTr("Meikade Github")
        highlighted: true
        onClicked: Qt.openUrlExternally("https://github.com/NileGroup/Meikade")
        Material.accent: MeikadeGlobals.masterColor
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
        color: MeikadeGlobals.foregroundColor
        horizontalAlignment: Text.AlignRight
    }
}
