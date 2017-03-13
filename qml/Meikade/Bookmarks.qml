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
import "globals"

BackHandlerView {
    id: bookmarks
    anchors.fill: parent
    clip: true
    color: MeikadeGlobals.backgroundColor
    viewMode: false

    readonly property string title: qsTr("Bookmarks")

    QtObject {
        id: privates
        property int favoritesId
        property int notesId
    }

    Connections {
        target: UserData
        onFavorited: bookmarks.refresh()
        onUnfavorited: bookmarks.refresh()
        onNoteChanged: bookmarks.refresh()
    }

    Rectangle {
        id: bookmark_frame
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: headerHeight+View.statusBarHeight
        anchors.right: View.defaultLayout? undefined : parent.right
        anchors.left: View.defaultLayout? parent.left : undefined
        width: localPortrait? parent.width : parent.width*1/3
        color: "#ffffff"

        PoemView {
            id: poem_view
            anchors.fill: parent
            color: "#00000000"
            header: Item {}
            clip: true
            editable: false
            headerVisible: false
            onItemSelected: {
                poem.poemId = pid
                poem.goTo(vid)
                poem.highlightItem(vid)
                bookmarks.viewMode = true
            }
        }

        Rectangle {
            y: View.defaultLayout? parent.height-height : -height
            x: View.defaultLayout? parent.width : 0
            width: parent.height
            height: 3*Devices.density
            rotation: View.defaultLayout? -90 : 90
            transformOrigin: Item.BottomLeft
            visible: !localPortrait
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 1.0; color: "#33000000" }
            }
        }
    }

    PoemView {
        id: poem
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: headerHeight+View.statusBarHeight
        width: localPortrait? parent.width : parent.width*2/3
        clip: true
        rememberBar: true
        x: {
            switch(View.layoutDirection) {
            case Qt.RightToLeft:
                return  bookmarks.viewMode? 0 : -width
            default:
            case Qt.LeftToRight:
                return  bookmarks.viewMode? parent.width - width : parent.width
            }
        }

        Behavior on x {
            NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
        }
    }

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: MeikadeGlobals.masterColor

        TitleBarShadow {
            width: header.width
            anchors.top: header.bottom
        }
    }

    function refresh() {
        var verses_str = UserData.favorites()

        poem_view.clear()
        for( var i=0; i<verses_str.length; i++ ) {
            var sid = verses_str[i]
            var pid = UserData.extractPoemIdFromStringId(sid)
            var vid = UserData.extractVerseIdFromStringId(sid)

            poem_view.add( pid, vid )
        }
    }

    Component.onCompleted: {
        refresh()
    }

    ActivityAnalizer { object: bookmarks; comment: "" }
}
