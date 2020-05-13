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
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Base 2.0
import AsemanQml.Awesome 2.0
import globals 1.0

Rectangle {
    height: 40*Devices.density
    color: Colors.deepBackground

    signal nextRequest()
    signal previousRequest()

    RowLayout {
        anchors.fill: parent

        Button {
            height: parent.height
            text: View.defaultLayout? Awesome.fa_angle_left : Awesome.fa_angle_right
            width: 50*Devices.density
            onClicked: previousRequest()
        }

        Item {
            id: title_column
            Layout.fillWidth: true
        }

        Button {
            height: parent.height
            text: View.defaultLayout? Awesome.fa_angle_right : Awesome.fa_angle_left
            width: 50*Devices.density
            onClicked: nextRequest()
        }
    }
}