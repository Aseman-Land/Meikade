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
    id: wait_dialog
    anchors.fill: parent

    property alias text: txt.text

    Text {
        id: txt
        y: parent.height*3/4
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12*globalFontDensity*Devices.fontDensity
        font.bold: true
        font.family: AsemanApp.globalFont.family
        color: "#ffffff"
    }

    CradleIndicator {
        id: cradle
        anchors.top: txt.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10*Devices.density
    }

    Connections{
        target: Meikade
        onCurrentLanguageChanged: initTranslations()
    }

    function initTranslations(){
        txt.text = qsTr("Please Wait")
    }

    Component.onCompleted: initTranslations()
}
