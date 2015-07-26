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

Item {
    id: poem_header
    width: 100
    height: title_column.height + title_column.y

    property int poemId: -1
    property bool favorited: false
    property alias font: txt1.font
    property color color: "#ffffff"

    onPoemIdChanged: {
        privates.signalBlocker = true
        var cat = Database.poemCat(poemId)
        txt1.text = Database.catName(cat)
        txt2.text = Database.poemName(poemId)
        favorited = UserData.isFavorited(poemId,0)

        var poet
        var book
        while( cat ) {
            book = poet
            poet = cat
            cat = Database.parentOf(cat)
        }

        poet_txt.text = Database.catName(poet) + ", " + Database.catName(book)
        privates.signalBlocker = false
    }

    onFavoritedChanged: {
        if( privates.signalBlocker )
            return
        if( favorited ) {
            UserData.favorite(poemId,0)
            main.showTooltip( qsTr("Favorited") )
        } else {
            UserData.unfavorite(poemId,0)
            main.showTooltip( qsTr("Unfavorited") )
        }
    }

    Connections {
        target: UserData
        onFavorited: if(pid == poem_header.poemId && vid == 0) favorited = true
        onUnfavorited: if(pid == poem_header.poemId && vid == 0) favorited = false
    }

    QtObject {
        id: privates
        property bool signalBlocker: false
    }

    Column {
        id: title_column
        y: 20*Devices.density + View.statusBarHeight
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10*Devices.density

        Text {
            id: txt1
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 13*globalFontDensity*Devices.fontDensity
            font.family: AsemanApp.globalFont.family
            wrapMode: TextInput.WordWrap
            color: poem_header.color
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: txt2
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 13*globalFontDensity*Devices.fontDensity
            font.family: AsemanApp.globalFont.family
            wrapMode: TextInput.WordWrap
            color: poem_header.color
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: title_column.spacing
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 32*Devices.density
            color: "#EC4334"

            Text{
                id: poet_txt
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 8*Devices.density
                font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                wrapMode: TextInput.WordWrap
                color: poem_header.color
                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                id: tools_row
                height: 32*Devices.density
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 1*Devices.density

                Button {
                    id: favorite
                    height: tools_row.height
                    width: height
                    icon: poem_header.favorited? "icons/favorites.png" : "icons/unfavorites.png"
                    normalColor: "#9D463E"
                    iconHeight: 14*Devices.density
                    onClicked: poem_header.favorited = !poem_header.favorited
                }

                Button {
                    id: share
                    height: tools_row.height
                    width: height
                    icon: "icons/share.png"
                    normalColor: "#9D463E"
                    iconHeight: 14*Devices.density
                    onClicked: {
                        var subject = Database.poemName(poem_header.poemId)
                        var poet
                        var catId = Database.poemCat(poem_header.poemId)
                        while( catId ) {
                            poet = Database.catName(catId)
                            subject = Database.catName(catId) + ", " + subject
                            catId = Database.parentOf(catId)
                        }

                        var message = ""
                        var vorders = Database.poemVerses(poem_header.poemId)
                        for( var i=0; i<vorders.length; i++ ) {
                            var vid = vorders[i]
                            if( i!=0 && Database.versePosition(poem_header.poemId,vid)===0 && Database.versePosition(poem_header.poemId,vid+1)===1 )
                                message = message + "\n"

                            message = message + Database.verseText(poem_header.poemId,vorders[i]) + "\n"

                        }

                        message = message + "\n\n" + poet

                        Devices.share(subject,message)
                    }
                }
            }
        }
    }
}
