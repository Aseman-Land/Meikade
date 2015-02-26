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
    id: mmenu
    width: 100
    height: 62
    color: "#222222"

    signal selected( string fileName )

    ListView {
        id: list
        anchors.fill: parent
        anchors.topMargin: 40*Devices.density
        anchors.bottomMargin: 40*Devices.density
        model: ListModel{}
        orientation: Qt.Vertical
        delegate: Rectangle {
            id: item
            width: list.width
            height: 50*Devices.density
            color: press? "#0d80ec" : "#00000000"

            property alias press: marea.pressed

            Text {
                id: txt
                anchors.left: parent.left
                anchors.right: item_rect.left
                anchors.margins: 20*Devices.density
                y: parent.height/2 - height/2 -1*Devices.density
                font.pixelSize: Devices.isMobile? 9*Devices.fontDensity : 11*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#ffffff"
                horizontalAlignment: Text.AlignRight
                text: name
            }

            Rectangle {
                id: item_rect
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: 10*Devices.density
                width: 15*Devices.density
                color: "#888888"
            }

            MouseArea {
                id: marea
                anchors.fill: parent
                onClicked: mmenu.selected(fileName)
            }
        }

        Component.onCompleted: {
            model.append({"name":qsTr("Home")     , "fileName":""})
            model.append({"name":qsTr("Search")   , "fileName":"cmd:search"})
            model.append({"name":qsTr("Bookmarks"), "fileName":"Bookmarks.qml"})
//            model.append({"name":qsTr("Notes")    , "fileName":"Notes.qml"})
            model.append({"name":qsTr("Configure"), "fileName":"Configure.qml"})
            model.append({"name":qsTr("OpenSource Projecs"), "fileName":"OpenSourceProjects.qml"})
            model.append({"name":qsTr("About")    , "fileName":"About.qml"})
            model.append({"name":qsTr("About Nile Team"), "fileName":"AboutNileTeam.qml"})
        }
    }

    ScrollBar {
        scrollArea: list; height: list.height; anchors.top: list.top
        anchors.left: list.left; color: "#ffffff"
    }
}
