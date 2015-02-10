/*
    Copyright (C) 2014 Aseman Labs
    http://labs.aseman.org

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
    id: about
    width: 100
    height: 62
    color: "#FF7340"

    property bool aboutText: true

    Image {
        anchors.fill: parent
        sourceSize: Qt.size(width,height)
        fillMode: Image.PreserveAspectCrop
        source: "images/intro.jpg"
    }

    Button{
        id: back_btn
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: View.statusBarHeight
        height: headerHeight
        radius: 0
        normalColor: "#00000000"
        highlightColor: "#88666666"
        textColor: "#ffffff"
        icon: "icons/back_light_64.png"
        iconHeight: 16*Devices.density
        fontSize: 11*Devices.fontDensity
        textFont.bold: false
        visible: backButton
        onClicked: {
            AsemanApp.back()
            Devices.hideKeyboard()
        }
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10*Devices.density

        Text {
            width: parent.width
            font.family: AsemanApp.globalFont.family
            font.pixelSize: 10*Devices.fontDensity
            text: qsTr("Meikade is a free (means, the users have the freedom to run, copy, distribute, study, change and improve the software) and opensource application by Aseman Labs")
            wrapMode: Text.WordWrap
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            visible: aboutText
        }

        Text {
            width: parent.width
            font.family: AsemanApp.globalFont.family
            font.pixelSize: 9*Devices.fontDensity
            text: "v1.0.7"
            wrapMode: Text.WordWrap
            color: "#ffffff"
            horizontalAlignment: Text.AlignRight
        }
    }
}
