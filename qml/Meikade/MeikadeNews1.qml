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

Column {
    id: column
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.right: parent.right

    Item {
        width: main.width - 40*Devices.density
        height: 200*Devices.density

        Flickable {
            id: flick
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            contentWidth: txt.width
            contentHeight: txt.height
            clip: true
            Text {
                id: txt
                width: flick.width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 10*Devices.density
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                color: "#333333"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("We change some poets on meikade.")
            }
        }

        ScrollBar {
            scrollArea: flick; height: flick.height
            anchors.left: parent.right; anchors.top: flick.top; color: "#333333"
            anchors.leftMargin: 2*Devices.density
        }
    }

    Button {
        width: parent.width
        textFont.family: AsemanApp.globalFont.family
        textFont.pixelSize: 10*globalFontDensity*Devices.fontDensity
        textColor: "#0d80ec"
        normalColor: "#00000000"
        highlightColor: "#660d80ec"
        text: qsTr("OK")
        onClicked: {
            AsemanApp.back()
        }
    }
}
