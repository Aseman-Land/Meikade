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

Rectangle {
    id: poems_page
    width: 100
    height: 62
    color: Meikade.nightTheme? "111111" :"#dddddd"
    clip: true

    property int catId: -1
    property alias poemId: view.poemId
    property bool viewMode: false
    property alias rememberBar: view.rememberBar

    property int duration: 400
    property int easingType: Easing.OutQuad

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
        networkFeatures.pushAction( ("Poem Selected: %1").arg(poemId) )
    }

    Poems {
        id: poems
        width: portrait? parent.width : parent.width*1/3
        height: parent.height
        anchors.right: View.layoutDirection==Qt.LeftToRight? undefined : parent.right
        anchors.left: View.layoutDirection==Qt.LeftToRight? parent.left : undefined
        catId: poems_page.catId
//        scale: ratio
        onItemSelected: {
            if( !poems_page.viewMode )
                poems_page.switchPages()
            view.poemId = pid
        }

        property real ratio: poems_page.viewMode && portrait? 0.8 : 1

        Behavior on ratio {
            NumberAnimation { easing.type: poems_page.easingType; duration: animations*poems_page.duration }
        }

        Rectangle{
            y: View.layoutDirection==Qt.LeftToRight? parent.height-height : -height
            x: View.layoutDirection==Qt.LeftToRight? parent.width : 0
            width: parent.height
            height: 3*Devices.density
            rotation: View.layoutDirection==Qt.LeftToRight? -90 : 90
            transformOrigin: Item.BottomLeft
            visible: !portrait
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
        width: portrait? parent.width : parent.width*2/3
        height: parent.height
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
