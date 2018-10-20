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

    Text {
        width: main.width - 40*Devices.density
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10*Devices.density
        font.family: AsemanApp.globalFont.family
        font.pixelSize: 9*globalFontDensity*Devices.fontDensity
        color: "#333333"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: qsTr("Error extracting database. There is no free space on your sd-card.\nMeikade need 150MB free space on your memory.")
    }

    Row {
        anchors.right: parent.right
        Button {
            textFont.family: AsemanApp.globalFont.family
            textFont.pixelSize: 10*globalFontDensity*Devices.fontDensity
            textColor: "#0d80ec"
            normalColor: "#00000000"
            highlightColor: "#660d80ec"
            text: qsTr("Dismiss")
            onClicked: {
                AsemanApp.back()
                Meikade.close()
            }
        }
    }
}
