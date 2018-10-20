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
import Meikade 1.0
import QtGraphicalEffects 1.0
import AsemanQml.Awesome 2.0
import "globals"

Item {
    id: goUpBtn
    anchors.fill: list

    property ListView list
    property int duration: 250

    readonly property bool atBeginning: list.atYBeginning

    onAtBeginningChanged: {
        if(atBeginning)
            BackHandler.removeHandler(goUpBtn)
        else
            BackHandler.pushHandler(goUpBtn, function(){ list.positionViewAtBeginning() })
    }

    Item {
        id: ascrollMask
        anchors.fill: parent
        visible: false

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 20*Devices.density
            width: 50*Devices.density
            height: width
            radius: width/2
        }
    }

    DropShadow {
        anchors.fill: ascrollMask
        horizontalOffset: 0*Devices.density
        verticalOffset: 1*Devices.density
        radius: 8.0
        samples: 17
        color: Qt.rgba(MeikadeGlobals.foregroundColor.r, MeikadeGlobals.foregroundColor.g, MeikadeGlobals.foregroundColor.b, 0.6)
        source: ascrollMask
        opacity: ascroll.opacity
        cached: true
    }

    Rectangle {
        id: ascroll

        property bool hide: list.atYBeginning

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20*Devices.density
        width: 50*Devices.density
        height: width
        radius: width/2
        color: MeikadeGlobals.backgroundColor
        opacity: hide? 0 : 1

        Behavior on opacity {
            NumberAnimation { duration: 500 }
        }

        Text {
            y: parent.height/2 - height/2 - 1*Devices.density
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 25*globalFontDensity*Devices.fontDensity
            font.family: Awesome.family
            color: MeikadeGlobals.foregroundColor
            text: Awesome.fa_angle_up
        }

        MouseArea {
            anchors.fill: parent
            onClicked: list.positionViewAtBeginning()
        }
    }
}
