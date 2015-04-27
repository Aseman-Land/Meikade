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
    id: item
    width: 100
    height: column.height + 30*Devices.density

    property int pid
    property int vid
    property int masterVid: vid

    property alias textColor: txt.color
    property alias font: txt.font
    property string text: txt.text + (txt_2.visible? "\n" + txt_2.text : "")

    property bool highlight: false

    onVidChanged: refresh()
    onPidChanged: refresh()

    Rectangle {
        id: highlight_rect
        color: "#ff0000"
        anchors.fill: parent
        opacity: item.highlight? 0.2 : 0

        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 350 }
        }
    }

    QtObject {
        id: privates
        property int position
        property int position_2
    }

    Column{
        id: column
        y: parent.height/2 - height/2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 30*Devices.density
        spacing: 10*Devices.density

        Text{
            id: txt
            anchors.right: parent.right
            anchors.left: parent.left
            font.pixelSize: Devices.isMobile? 9*Devices.fontDensity : 11*Devices.fontDensity
            font.family: globalPoemFontFamily
            wrapMode: TextInput.WordWrap
            horizontalAlignment: Text.AlignRight
        }

        Text{
            id: txt_2
            anchors.left: parent.left
            anchors.right: parent.right
            font: txt.font
            wrapMode: TextInput.WordWrap
            visible: privates.position==0 && privates.position_2==1
            color: item.textColor
            horizontalAlignment: Text.AlignLeft
        }
    }

    function refresh(){
        var psn1 = Database.versePosition(item.pid,item.vid)
        var psn2
        var txt1 = Database.verseText(item.pid,item.vid)
        var txt2

        if( item.vid == 0 ) {
            var name = Database.poemName(poemId)
            var catId = Database.poemCat(poemId)
            while( catId ) {
                name = Database.catName(catId) + ", " + name
                catId = Database.parentOf(catId)
            }

            txt1 = name
        }

        if( psn1 === 0 ) {
            psn2 = Database.versePosition(item.pid,item.vid+1)
            txt2 = Database.verseText(item.pid,item.vid+1)

            privates.position = psn1
            privates.position_2 = psn2
            txt.text = txt1
            txt_2.text = txt2
            masterVid = vid
        }
        else
        if( psn1 === 1 ) {
            psn2 = Database.versePosition(item.pid,item.vid-1)
            txt2 = Database.verseText(item.pid,item.vid-1)

            privates.position = psn2
            privates.position_2 = psn1
            txt.text = txt2
            txt_2.text = txt1
            masterVid = vid-1
        }
        else
        {
            privates.position = psn1
            privates.position_2 = -1
            txt.text = txt1
            txt_2.text = ""
        }
    }
}
