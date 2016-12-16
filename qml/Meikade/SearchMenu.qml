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

MenuTypeA {
    id: search_menu
    width: 100
    height: 62

    property alias keyword: search_list.keyword
    property bool searchOnEdit: false

    property int duration: 400
    property int easingType: Easing.OutQuad

    SearchList {
        id: search_list
        width: parent.width
        height: parent.height
        scale: search_menu.searchOnEdit? 0.8 : 1
        onItemSelected: {
            view.poemId = poem_id
            view.goTo(vid)
            view.highlightItem(vid)

            if( !search_menu.searchOnEdit )
                search_menu.switchPages()
        }

        Behavior on scale {
            NumberAnimation { easing.type: search_menu.easingType; duration: animations*search_menu.duration }
        }
    }

    Rectangle {
        id: black
        anchors.fill: parent
        color: "#000000"
        opacity: (1 - search_list.scale)*3
    }

    PoemView {
        id: view
        width: parent.width
        anchors.topMargin: 82*Devices.density
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        x: search_menu.searchOnEdit? 0 : -width - shadow.width

        Behavior on x {
            NumberAnimation { easing.type: search_menu.easingType; duration: animations*search_menu.duration }
        }

        Rectangle{
            id: shadow
            y: View.defaultLayout? parent.height-height : -height
            x: View.defaultLayout? parent.width : 0
            width: parent.height
            height: 3*Devices.density
            rotation: View.defaultLayout? -90 : 90
            transformOrigin: Item.BottomLeft
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 1.0; color: "#33000000" }
            }
        }
    }

    function toggleEdit() {
        if( view.onEdit ) {
            view.closeEdit()
            return
        }
        switchPages()
    }

    function switchPages() {
        search_menu.searchOnEdit = !search_menu.searchOnEdit
    }
}
