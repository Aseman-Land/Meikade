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
    clip: true
    color: MeikadeGlobals.backgroundColor
    viewMode: false

    readonly property int poetId: -1
    readonly property string title: qsTr("Bookmarks")
    readonly property bool titleBarHide: !forceTitleBarShow && header.hide && (localPortrait || Devices.isMobile)
    property bool forceTitleBarShow: false

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
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.right: View.defaultLayout? undefined : parent.right
        anchors.left: View.defaultLayout? parent.left : undefined
        width: localPortrait? parent.width : parent.width*1/3
        color: MeikadeGlobals.backgroundAlternativeColor

        BookmarksView {
            id: bookmark_view
            anchors.fill: parent
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
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: localPortrait? parent.width : parent.width*2/3
        clip: true
        allowHideHeader: true
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
        onForceTitleBarShowRequest: forceTitleBarShow = stt

        Behavior on x {
            NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
        }
    }

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: MeikadeGlobals.masterColor
        y: titleBarHide? -Devices.standardTitleBarHeight : 0

        property bool hide: false

        Behavior on y {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
        }

        TitleBarShadow {
            width: header.width
            visible: !Devices.isIOS
            anchors.top: header.bottom
        }
    }

    function refresh() {
        if(poetId == -1)
            return

        var verses_str = UserData.favorites()

        bookmark_view.clear()
        for( var i=0; i<verses_str.length; i++ ) {
            var sid = verses_str[i]
            var pid = UserData.extractPoemIdFromStringId(sid)
            var vid = UserData.extractVerseIdFromStringId(sid)

            var poet
            var cat = Database.poemCat(pid)
            while(cat) {
                poet = cat
                cat = Database.parentOf(cat)
            }

            if(poet == poetId)
                bookmark_view.add( pid, vid )
        }

        if(bookmark_view.count == 0) {
            BackHandler.pushHandler(bookmarks, bookmarks.destroy)
            BackHandler.back()
        }
    }

    function hideHeader() {
        header.hide = true
    }

    function showHeader() {
        header.hide = false
    }

    Component.onCompleted: {
        refresh()
        MeikadeGlobals.categoriesList.append(this)
    }
    Component.onDestruction: MeikadeGlobals.categoriesList.removeAll(this)

    ActivityAnalizer { object: bookmarks; comment: "" }
}
