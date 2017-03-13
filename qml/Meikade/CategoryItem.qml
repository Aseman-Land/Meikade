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
import Meikade 1.0
import QtQuick.Layouts 1.3
import "globals"

RowLayout {
    id: item
    layoutDirection: View.layoutDirection

    property int cid
    property bool root

    PoetImageProvider {
        id: image_provider
        poet: root? Database.catPoetId(cid) : 0
    }

    Image {
        id: img

        Layout.preferredHeight: root? parent.height - 8*Devices.density : 0
        Layout.preferredWidth: Layout.preferredHeight
        Layout.alignment: Qt.AlignHCenter
        Layout.margins: 4*Devices.density

        sourceSize: Qt.size(width,height)
        fillMode: Image.PreserveAspectFit
        source: root? image_provider.path : ""
    }

    Text{
        id: txt

        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter

        horizontalAlignment: View.defaultLayout? Qt.AlignLeft : Qt.AlignRight
        text: cid==-1? qsTr("Other Poems") : Database.catName(cid)
        font.pixelSize: Devices.isMobile? 9*globalFontDensity*Devices.fontDensity : 10*globalFontDensity*Devices.fontDensity
        font.family: AsemanApp.globalFont.family
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color: MeikadeGlobals.foregroundColor
    }
}
