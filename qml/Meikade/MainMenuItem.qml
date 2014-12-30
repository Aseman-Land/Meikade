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
    id: menu_item
    anchors.fill: parent

    property variant item
    property variant fallBackHandler

    onItemChanged: {
        if( !item )
            return

        item.parent = item_menu_frame
        item.anchors.fill = item_menu_frame
    }

    Item {
        id: item_menu_frame
        width: parent.width
        height: parent.height
        x: menu_item.item? 0 : -width
        clip: true

        MouseArea {
            anchors.fill: parent
        }

        Behavior on x {
            NumberAnimation{ easing.type: Easing.OutCubic; duration: 400 }
        }
    }

    Timer {
        id: item_close_timer
        interval: 400
        repeat: false
        onTriggered: menu_item.destroy()
    }

    function close() {
        if( item_close_timer.running )
            return

        item_menu_frame.x = -width
        item_close_timer.restart()
    }

    function back() {
        close()
        return true
    }

    Component.onCompleted: {
        fallBackHandler = BackHandler
        BackHandler = menu_item
    }
    Component.onDestruction: if( BackHandler == menu_item ) BackHandler = fallBackHandler
}
