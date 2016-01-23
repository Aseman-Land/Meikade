/*
    Copyright (C) 2015 Nile Group
    http://nilegroup.org

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

BackHandlerView {
    id: bookmarks
    width: 100
    height: 62
    color: "#ffffff"
    viewMode: false

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

    PoemView {
        id: poem
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: headerHeight+View.statusBarHeight
        width: parent.width
        clip: true
        rememberBar: true
        x: bookmarks.viewMode? 0 : -width

        Behavior on x {
            NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
        }
    }

    Rectangle {
        id: bookmark_frame
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: headerHeight+View.statusBarHeight
        width: parent.width
        x: bookmarks.viewMode? width : 0
        color: "#ffffff"

        Behavior on x {
            NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
        }

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
    }

    Rectangle {
        anchors.fill: title
        anchors.topMargin: -View.statusBarHeight
        color: "#881010"

        TitleBarShadow {
            width: parent.width
            anchors.top: parent.bottom
        }
    }

    Header {
        id: title
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: View.statusBarHeight
        titleFont.pixelSize: 12*globalFontDensity*Devices.fontDensity
        light: true
        text: qsTr("Bookmarks")
        backButtonText: ""
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
