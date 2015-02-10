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

Item {
    id: item

    property int cid
    property bool root

    Image {
        id: img
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 4*Devices.density
        width: height
        sourceSize: Qt.size(width,height)
        fillMode: Image.PreserveAspectFit
        source: root? "poets/" + Database.catPoetId(cid) + ".png" : ""
    }

    Text{
        id: txt
        anchors.left: parent.left
        anchors.right: root? img.left : parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 8*Devices.density
        horizontalAlignment: Text.AlignRight
        text: Database.catName(cid)
        font.pixelSize: Devices.isMobile? 9*Devices.fontDensity : 11*Devices.fontDensity
        font.family: AsemanApp.globalFont.family
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }
}
