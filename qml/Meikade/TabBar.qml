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
    id: tabbar
    width: 100
    height: 62

    property alias selectedIndex: view.selectedIndex

    signal itemSelected( int tid )

    AsemanListView {
        id: view
        anchors.fill: parent
        highlightMoveDuration: 250
        orientation: Qt.Horizontal
        layoutDirection: View.layoutDirection

        property int selectedIndex: 0

        model: ListModel {}
        delegate: Item {
            id: item
            width: txt.width + 20*Devices.density
            height: parent.height

            property int tid: identifier
            property alias press: marea.pressed
            property string name: text

            Text{
                id: txt
                x: 10*Devices.density
                anchors.verticalCenter: parent.verticalCenter
                text: item.name
                font.pixelSize: view.selectedIndex == item.tid? 18*globalFontDensity*Devices.fontDensity : 12*globalFontDensity*Devices.fontDensity
                font.underline: view.selectedIndex == item.tid
                font.family: AsemanApp.globalFont.family
                color: item.press? "#0d80ec" : "#ffffff"
            }

            MouseArea{
                id: marea
                anchors.fill: parent
                onClicked: {
                    view.selectedIndex = item.tid
                    tabbar.itemSelected(item.tid)
                }
            }
        }

        focus: true
        currentIndex: -1

        function add( name ) {
            var tid = view.count
            model.append({"identifier": tid, "text": name})
            return tid
        }

        function clear() {
            model.clear()
        }
    }

    function add( name ) {
        return view.add(name)
    }

    function clear() {
        view.clear()
    }
}
