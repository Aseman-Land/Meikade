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

Item {
    anchors.fill: parent

    ListView {
        id: preference_list
        anchors.fill: parent
        anchors.topMargin: 4*Devices.density
        anchors.bottomMargin: 4*Devices.density
        highlightMoveDuration: 250

        model: ListModel {}
        delegate: Rectangle {
            id: item
            width: preference_list.width
            height: 60*Devices.density
            color: press? "#3B97EC" : "#00000000"

            property string text: name
            property alias press: marea.pressed

            Image {
                id: tik_img
                anchors.left: parent.left
                anchors.leftMargin: 10*Devices.density
                anchors.verticalCenter: parent.verticalCenter
                width: height
                height: 15*Devices.density
                source: "icons/tik.png"
                visible: Meikade.currentLanguage == item.text
            }

            Text{
                id: txt
                anchors.left: tik_img.right
                anchors.right: parent.right
                anchors.margins: 30*Devices.density
                anchors.leftMargin: 10*Devices.density
                y: parent.height/2 - height/2
                text: parent.text
                font.pixelSize: 11*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#ffffff"
            }

            MouseArea{
                id: marea
                anchors.fill: parent
                onClicked: {
                    Meikade.setCurrentLanguage(item.text)
                    showTooltip( qsTr("Language changed") )
                }
            }
        }

        focus: true
        highlight: Rectangle { color: "#3B97EC"; radius: 3; smooth: true }
        currentIndex: -1

        onCurrentItemChanged: {
            if( !currentItem )
                return
        }

        Component.onCompleted: {
            model.clear()

            var langs = Meikade.languages()
            for( var i=0; i<langs.length; i++ )
                model.append({"name": langs[i]})

            focus = true
        }
    }

    ScrollBar {
        scrollArea: preference_list; height: preference_list.height
        anchors.right: preference_list.right; anchors.top: preference_list.top;color: "#ffffff"
    }
}
