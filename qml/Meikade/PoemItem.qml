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
    property int masterVid: {
        var psn1 = Database.versePosition(item.pid,item.vid)
        if( psn1 === 0 )
            return vid
        else
        if( psn1 === 1 )
            return vid-1
        else
            return vid
    }

    property alias textColor: txt.color
    property alias font: txt.font
    property string text: txt.text + (txt_2.visible? "\n" + txt_2.text : "")

    property bool highlight: false

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
        property int position: {
            var psn1 = Database.versePosition(item.pid,item.vid)
            if( psn1 === 0 )
                return psn1
            else
            if( psn1 === 1 )
                return Database.versePosition(item.pid,item.vid-1)
            else
                return psn1
        }

        property int position_2: {
            var psn1 = Database.versePosition(item.pid,item.vid)
            if( psn1 === 0 )
                return Database.versePosition(item.pid,item.vid+1)
            else
            if( psn1 === 1 )
                return psn1
            else
                return -1
        }
    }

    Column{
        id: column
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 30*Devices.density
        spacing: 10*Devices.density

        Text {
            id: txt
            width: parent.width
            font.pixelSize: Devices.isMobile? 9*globalFontDensity*Devices.fontDensity : 11*globalFontDensity*Devices.fontDensity
            font.family: globalPoemFontFamily
            wrapMode: TextInput.WordWrap
            horizontalAlignment: TextTools.directionOf(text)==Qt.LeftToRight? Text.AlignLeft : Text.AlignRight
            color: Meikade.nightTheme? "#ffffff" : "#111111"
            text: {
                var psn1 = Database.versePosition(item.pid,item.vid)
                var txt1 = Database.verseText(item.pid,item.vid)

                if( item.vid == 0 ) {
                    var name = Database.poemName(poemId)
                    var catId = Database.poemCat(poemId)
                    while( catId ) {
                        name = Database.catName(catId) + ", " + name
                        catId = Database.parentOf(catId)
                    }

                    txt1 = name
                }

                if( psn1 === 0 )
                    return txt1
                else
                if( psn1 === 1 )
                    return Database.verseText(item.pid,item.vid-1)
                else
                    return txt1
            }
        }

        Text{
            id: txt_2
            width: parent.width
            font: txt.font
            wrapMode: TextInput.WordWrap
            visible: privates.position==0 && privates.position_2==1
            color: item.textColor
            horizontalAlignment: TextTools.directionOf(text)==Qt.LeftToRight? Text.AlignRight : Text.AlignLeft
            text: {
                var psn1 = Database.versePosition(item.pid,item.vid)
                var txt1 = Database.verseText(item.pid,item.vid)

                if( item.vid == 0 ) {
                    var name = Database.poemName(poemId)
                    var catId = Database.poemCat(poemId)
                    while( catId ) {
                        name = Database.catName(catId) + ", " + name
                        catId = Database.parentOf(catId)
                    }

                    txt1 = name
                }

                if( psn1 === 0 )
                    return Database.verseText(item.pid,item.vid+1)
                else
                if( psn1 === 1 ) {
                    return txt1
                }
                else
                    return ""
            }
        }
    }
}
