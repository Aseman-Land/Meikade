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

Item {

    Text {
        id: txt
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        font.family: AsemanApp.globalFont.family
        font.pixelSize: 10*Devices.fontDensity
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
        color: "#666666"
    }

    Canvas {
        anchors.fill: parent
        transform: Scale { origin.x: width/2; origin.y: height; xScale: View.layoutDirection==Qt.LeftToRight?1:-1}

        property color strokeColor: "#aaaaaa"
        property real strokeWidth: 2

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0,0,width,height)

            var startX = parent.width - 80*Devices.density
            var startY = parent.height - 38*Devices.density
            var endX = width/2
            var endY = txt.y + txt.height

            ctx.strokeStyle = strokeColor
            ctx.lineWidth = strokeWidth*Devices.density

            ctx.beginPath()
            ctx.moveTo(startX , startY)
            ctx.bezierCurveTo(startX, startY ,
                              endX, startY,
                              endX, endY);
            ctx.stroke()
        }

        Component.onCompleted: requestPaint()
    }

    Connections{
        target: Meikade
        onCurrentLanguageChanged: initTranslations()
    }

    function initTranslations(){
        txt.text = qsTr("To Start, Download new poet")
    }

    Component.onCompleted: {
        initTranslations()
    }
}
