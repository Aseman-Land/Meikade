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
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import AsemanTools 1.0
import AsemanTools.Awesome 1.0

Rectangle {
    height: 40*Devices.density
    color: Meikade.nightTheme? "#222222" : "#ffffff"

    signal nextRequest()
    signal previousRequest()

    RowLayout {
        anchors.fill: parent
        layoutDirection: View.layoutDirection

        Button {
            height: parent.height
            textFont.family: Awesome.family
            textFont.pixelSize: 14*globalFontDensity*Devices.fontDensity
            textColor: Meikade.nightTheme? "#eeeeee" : "#444444"
            text: View.defaultLayout? Awesome.fa_angle_left : Awesome.fa_angle_right
            normalColor: "#00000000"
            highlightColor: "#55000000"
            width: 50*Devices.density
            onClicked: previousRequest()
        }

        Item {
            id: title_column
            anchors.verticalCenter: parent.verticalCenter
            Layout.fillWidth: true
        }

        Button {
            height: parent.height
            textFont.family: Awesome.family
            textFont.pixelSize: 14*globalFontDensity*Devices.fontDensity
            textColor: Meikade.nightTheme? "#eeeeee" : "#444444"
            text: View.defaultLayout? Awesome.fa_angle_right : Awesome.fa_angle_left
            normalColor: "#00000000"
            highlightColor: "#55000000"
            width: 50*Devices.density
            onClicked: nextRequest()
        }
    }
}
