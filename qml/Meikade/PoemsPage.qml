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

Rectangle {
    id: poems_page
    width: 100
    height: 62
    color: MeikadeGlobals.backgroundColor
    clip: true

    property int catId: -1
    property alias poemId: view.poemId
    property bool viewMode: false
    property alias rememberBar: view.rememberBar

    property int duration: 400
    property int easingType: Easing.OutQuad

    signal forceTitleBarShowRequest(bool stt)

    onViewModeChanged: {
        if( viewMode )
            BackHandler.pushHandler(poems_page, poems_page.back)
        else
            BackHandler.removeHandler(poems_page)
    }

    onPoemIdChanged: {
        view.goToBegin()
        if(poemId > 0) {
            var catId = Database.poemCat(poemId)
            if(catId > 0)
                poems_page.catId = catId
        }
        AsemanServices.meikade.pushAction( ("Poem Selected: %1").arg(poemId), null )
    }

    Poems {
        id: poems
        width: localPortrait? parent.width : parent.width*1/3
        height: parent.height
        anchors.right: View.defaultLayout? undefined : parent.right
        anchors.left: View.defaultLayout? parent.left : undefined
        catId: poems_page.catId
//        scale: ratio
        onItemSelected: {
            if( !poems_page.viewMode )
                poems_page.switchPages()
            view.poemId = pid
        }

        property real ratio: poems_page.viewMode && localPortrait? 0.8 : 1

        Behavior on ratio {
            NumberAnimation { easing.type: poems_page.easingType; duration: animations*poems_page.duration }
        }

        Rectangle{
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

    Rectangle {
        id: black
        anchors.fill: parent
        color: "#000000"
        opacity: (1 - poems.ratio)*3
    }

    PoemView {
        id: view
        width: localPortrait? parent.width : parent.width*2/3
        height: parent.height
        allowHideHeader: true
        onForceTitleBarShowRequest: poems_page.forceTitleBarShowRequest(stt)
        x: {
            switch(View.layoutDirection) {
            case Qt.RightToLeft:
                return  poems_page.viewMode? 0 : -width
            default:
            case Qt.LeftToRight:
                return  poems_page.viewMode? parent.width - width : parent.width
            }
        }
        rememberBar: true

        Behavior on x {
            NumberAnimation { easing.type: poems_page.easingType; duration: animations*poems_page.duration }
        }
    }

    function switchPages() {
        poems_page.viewMode = !poems_page.viewMode
    }

    function back() {
        poems_page.viewMode = false
        showHeader()
    }

    function showRandomPoem(id) {
        var poem = -1
        var poems = Database.catPoems(id)
        if(poems.length != 0)
        {
            var poem_id_rnd = Math.floor(Math.random()*poems.length)
            if(poem_id_rnd == poems.length)
                poem_id_rnd--

            poem = poems[poem_id_rnd]
        }

        if(poem == -1 || !poem)
            return false

        poemId = poem
        viewMode = true
    }

    ActivityAnalizer { object: poems_page; comment: poems_page.catId }
}
