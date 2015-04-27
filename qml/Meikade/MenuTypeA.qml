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

Rectangle {
    id: menu_type_a
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: parent.width
    x: menu_type_a.show? 0 : parent.width+menu_type_a.shadowSize
    color: "#ffffff"
    visible: false

    Behavior on x {
        NumberAnimation { easing.type: Easing.OutCubic; duration: animations*menu_type_a.duration }
    }

    MouseArea{
        anchors.fill: parent
    }

    property bool show: false
    property real shadowSize: 5*Devices.density
    property int duration: 300

    onShowChanged: {
        if( show ) {
            visible = true
            hide_timer.stop()
        }
        else
            hide_timer.restart()
    }

    Rectangle{
        id: shadow
        x: -height
        y: -height
        width: parent.height
        height: menu_type_a.shadowSize
        rotation: 90
        transformOrigin: Item.BottomLeft
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#66000000" }
            GradientStop { position: 1.0; color: "#00000000" }
        }
    }

    Timer{
        id: hide_timer
        interval: menu_type_a.duration
        repeat: false
        onTriggered: menu_type_a.visible = false
    }
}
