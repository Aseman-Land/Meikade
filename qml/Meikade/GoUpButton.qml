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
import AsemanTools 1.0
import Meikade 1.0
import QtGraphicalEffects 1.0
import AsemanTools.Awesome 1.0

Item {
    id: goUpBtn
    anchors.fill: list

    property ListView list
    property int duration: 250
    property bool modernButton: SystemInfo.cpuCores>1

    readonly property bool atBeginning: list.atYBeginning

    onAtBeginningChanged: {
        if(atBeginning)
            BackHandler.removeHandler(goUpBtn)
        else
            BackHandler.pushHandler(goUpBtn, function(){ list.positionViewAtBeginning() })
    }

    Rectangle {
        id: blurFrame
        anchors.fill: parent
        visible: false

        FastBlur {
            anchors.fill: parent
            source: modernButton? list : null
            radius: 64
        }
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
        horizontalOffset: 1*Devices.density
        verticalOffset: 1*Devices.density
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: modernButton? ascrollMask : null
        opacity: ascroll.opacity
        visible: modernButton
    }

    OpacityMask {
        anchors.fill: ascrollMask
        source: modernButton? blurFrame : null
        maskSource: ascrollMask
        opacity: ascroll.opacity
        visible: modernButton
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
        color: modernButton? "#66ffffff" : "#eeeeee"
        opacity: hide? 0 : 1

        Behavior on opacity {
            NumberAnimation { duration: 500 }
        }

        Text {
            y: parent.height/2 - height/2 - 1*Devices.density
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 25*globalFontDensity*Devices.fontDensity
            font.family: Awesome.family
            color: "#333333"
            text: Awesome.fa_angle_up
        }

        MouseArea {
            anchors.fill: parent
            onClicked: list.positionViewAtBeginning()
        }
    }
}
