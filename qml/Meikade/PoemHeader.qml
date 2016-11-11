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
import QtQuick.Controls 2.0
import AsemanTools 1.0
import AsemanTools.Awesome 1.0

Item {
    id: poem_header
    width: 100
    height: 190*Devices.density

    property int poemId: -1
    property int poetId: -1
    property int catId: -1
    property bool favorited: false
    property bool toolsOpened: false
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

        poet_txt.text = Database.catName(poet)
        book_txt.text = Database.catName(book)

        poetId = poet
        catId = book

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
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10*Devices.density

        Text {
            id: txt1
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 13*globalFontDensity*Devices.fontDensity
            font.family: AsemanApp.globalFont.family
            wrapMode: Text.WordWrap
            color: poem_header.color
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: txt2
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 13*globalFontDensity*Devices.fontDensity
            font.family: AsemanApp.globalFont.family
            wrapMode: Text.WordWrap
            color: poem_header.color
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: title_column.spacing
        }
    }

    Rectangle {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 32*Devices.density
        color: "#EC4334"

        Row {
            anchors.right: View.layoutDirection==Qt.LeftToRight? undefined : parent.right
            anchors.left: View.layoutDirection==Qt.LeftToRight? parent.left : undefined
            anchors.verticalCenter: parent.verticalCenter
            layoutDirection: View.layoutDirection
            anchors.margins: spacing
            spacing: 4*Devices.density

            Text {
                id: linkText
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                font.family: Awesome.family
                text: View.layoutDirection==Qt.LeftToRight? Awesome.fa_chevron_right : Awesome.fa_chevron_left
                color: poem_header.color
            }

            Text {
                id: poet_txt
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                wrapMode: TextInput.WordWrap
                color: poem_header.color
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        page.backToPoet(poetId)
                    }
                }
            }

            Item { width: 8*Devices.density; height: 1 }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                font.family: Awesome.family
                text: linkText.text
                color: poem_header.color
            }

            Text {
                id: book_txt
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                wrapMode: TextInput.WordWrap
                color: poem_header.color
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        page.backToCats(catId, poetId)
                    }
                }
            }
        }

        Row {
            id: menu_row
            height: 32*Devices.density
            anchors.right: View.layoutDirection==Qt.LeftToRight? parent.right : undefined
            anchors.left: View.layoutDirection==Qt.LeftToRight? undefined : parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1*Devices.density

            Button {
                id: menu
                height: menu_row.height
                width: height
                normalColor: "#44000000"
                highlightColor: Qt.rgba(0, 0, 0, 0.4)
                iconHeight: 14*Devices.density
                onClicked: optionsMenu.open()

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 11*globalFontDensity*Devices.fontDensity
                    font.family: Awesome.family
                    color: "white"
                    text: Awesome.fa_ellipsis_v
                }

                Menu {
                    id: optionsMenu
                    x: View.layoutDirection==Qt.LeftToRight? parent.width - width : 0
                    transformOrigin: View.layoutDirection==Qt.LeftToRight? Menu.TopRight : Menu.TopLeft
                    modal: true

                    MenuItem {
                        text: poem_header.favorited? qsTr("Unfavorite") : qsTr("Favorite")
                        onTriggered: poem_header.favorited = !poem_header.favorited
                    }
                    MenuItem {
                        text: qsTr("Share")
                        onTriggered: {
                            networkFeatures.pushAction( ("Share Poem: %1").arg(poem_header.poemId) )
                            var subject = Database.poemName(poem_header.poemId)
                            var catId = Database.poemCat(poem_header.poemId)
                            while( catId ) {
                                subject = Database.catName(catId) + ", " + subject
                                catId = Database.parentOf(catId)
                            }

                            var message = getPoemText()
                            Devices.share(subject,message)
                        }
                    }
                    MenuItem {
                        text: qsTr("Copy")
                        onTriggered: {
                            networkFeatures.pushAction( ("Copy Poem: %1").arg(poem_header.poemId) )
                            var message = getPoemText()
                            Devices.clipboard = message
                        }
                    }
                }
            }
        }
    }

    function getPoemText() {
        var poet
        var catId = Database.poemCat(poem_header.poemId)
        while( catId ) {
            poet = Database.catName(catId)
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
        return message
    }
}
