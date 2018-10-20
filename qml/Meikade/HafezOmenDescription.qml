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
import AsemanQml.Base 2.0

Rectangle {
    width: 100
    height: 62
    color: "#f0f0f0"

    AsemanFlickable {
        id: flick
        anchors.fill: parent
        anchors.leftMargin: 20*Devices.density
        anchors.rightMargin: 20*Devices.density
        anchors.bottomMargin: View.navigationBarHeight
        flickableDirection: Flickable.VerticalFlick
        contentWidth: column.width
        contentHeight: column.height
        clip: true

        Column {
            id: column
            width: flick.width

            Item {width: 20; height: 20*Devices.density}

            Image {
                width: height*3/4
                height: parent.width*0.6
                sourceSize: Qt.size(width,height)
                source: "icons/hafez_omen.jpg"
                anchors.horizontalCenter: parent.horizontalCenter
                rotation: 90
                transformOrigin: Item.Center
            }

            Item {width: 2; height: 10*Devices.density}

            TextEdit {
                width: parent.width
                wrapMode: TextEdit.Wrap
                readOnly: true
                selectByMouse: false
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 13*Devices.density
                color: "#333333"
                text: Meikade.aboutHafezOmen()
            }
        }
    }

    ScrollBar {
        scrollArea: flick; height: flick.height
        anchors.right: parent.right; anchors.top: flick.top; color: "#333333"
        anchors.rightMargin: 2*Devices.density
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }
}
