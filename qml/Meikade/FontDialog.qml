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
import AsemanTools.Awesome 1.0

Item {
    anchors.fill: parent

    AsemanListView {
        id: prefrences
        anchors.fill: parent
        anchors.topMargin: 4*Devices.density
        anchors.bottomMargin: 4*Devices.density
        highlightMoveDuration: 250
        clip: true

        model: ListModel {}
        delegate: Rectangle {
            id: item
            width: prefrences.width
            height: txt.height + 30*Devices.density
            color: press? "#880d80ec" : "#00000000"

            property string font: fontName
            property alias press: marea.pressed

            Text {
                id: tik_img
                anchors.left: parent.left
                anchors.leftMargin: 10*Devices.density
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 15*globalFontDensity*Devices.fontDensity
                font.family: Awesome.family
                color: "#5d5d5d"
                text: Awesome.fa_check
                visible: Meikade.currentLanguage == item.text
            }

            Text{
                id: txt
                anchors.left: tik_img.right
                anchors.right: parent.right
                anchors.margins: 30*Devices.density
                anchors.leftMargin: 10*Devices.density
                y: parent.height/2 - height/2
                font.pixelSize: 11*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#333333"
                text: item.font
                wrapMode: TextInput.WordWrap
            }

            MouseArea{
                id: marea
                anchors.fill: parent
                onClicked: {
                    Meikade.poemsFont = item.font
                }
            }
        }

        focus: true
        highlight: Rectangle { color: "#3B97EC"; radius: 3; smooth: true }
        currentIndex: -1

        function refresh() {
            model.clear()

            var fonts = Meikade.availableFonts()
            for( var i=0; i<fonts.length; i++ )
                model.append({"fontName": fonts[i]})

            focus = true
        }

        Component.onCompleted: refresh()
    }

    ScrollBar {
        scrollArea: prefrences; height: prefrences.height
        anchors.right: prefrences.right; anchors.top: prefrences.top; color: "#ffffff"
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }
}
