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

AsemanObject {
    id: analizer

    property string comment
    property variant object
    property string objectName

    onObjectChanged: if(object) objectName = Tools.className(object)

    Timer {
        id: timer
        interval: 100
        repeat: true
        onTriggered: count++
        Component.onCompleted: begin()

        property int count
    }

    function begin() {
        timer.count = 0
        timer.restart()
    }

    function end() {
        if(!timer.running)
            return

        timer.stop()
        networkFeatures.pushActivity(objectName, timer.count*100, comment)
    }

    Component.onDestruction: end()
}
