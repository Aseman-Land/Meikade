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
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import AsemanTools 1.0
import AsemanTools.Awesome 1.0
import "globals"

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

    signal nextRequest()
    signal previousRequest()

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
        catId = book? book : -1

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

    NullMouseArea { anchors.fill: parent }

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height - header.height
        layoutDirection: View.layoutDirection

        Button {
            height: parent.height
            textFont.family: Awesome.family
            textFont.pixelSize: 14*globalFontDensity*Devices.fontDensity
            textColor: phrase_txt.color
            text: View.defaultLayout? Awesome.fa_angle_left : Awesome.fa_angle_right
            normalColor: "#00000000"
            highlightColor: Qt.rgba(MeikadeGlobals.masterColor.r, MeikadeGlobals.masterColor.g, MeikadeGlobals.masterColor.b, 0.5)
            width: 30*Devices.density
            onClicked: previousRequest()
        }

        Column {
            id: title_column
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 10*Devices.density

            Layout.fillWidth: true

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

        Button {
            height: parent.height
            textFont.family: Awesome.family
            textFont.pixelSize: 14*globalFontDensity*Devices.fontDensity
            textColor: phrase_txt.color
            text: View.defaultLayout? Awesome.fa_angle_right : Awesome.fa_angle_left
            normalColor: "#00000000"
            highlightColor: Qt.rgba(MeikadeGlobals.masterColor.r, MeikadeGlobals.masterColor.g, MeikadeGlobals.masterColor.b, 0.5)
            width: 30*Devices.density
            onClicked: nextRequest()
        }
    }

    Rectangle {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 32*Devices.density
        color: Qt.lighter(MeikadeGlobals.masterColor)

        Row {
            anchors.right: View.defaultLayout? undefined : parent.right
            anchors.left: View.defaultLayout? parent.left : undefined
            anchors.verticalCenter: parent.verticalCenter
            layoutDirection: View.layoutDirection
            anchors.margins: spacing
            spacing: 4*Devices.density

            Text {
                id: linkText
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                font.family: Awesome.family
                text: View.defaultLayout? Awesome.fa_chevron_right : Awesome.fa_chevron_left
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
            anchors.right: View.defaultLayout? parent.right : undefined
            anchors.left: View.defaultLayout? undefined : parent.left
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

                Rectangle {
                    anchors.centerIn: parent
                    width: selectMode? parent.width : 0
                    height: width
                    color: MeikadeGlobals.masterColor
                    visible: false

                    Behavior on width {
                        NumberAnimation { easing.type: Easing.OutBack; easing.overshoot: 5*Devices.density; duration: 250 }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 12*globalFontDensity*Devices.fontDensity
                    font.family: Awesome.family
                    color: "white"
                    text: Awesome.fa_ellipsis_v
                    scale: selectMode? 1 : 0.95

                    Behavior on scale {
                        NumberAnimation { easing.type: Easing.OutBack; easing.overshoot: 160; duration: 250 }
                    }
                }

                Menu {
                    id: optionsMenu
                    x: View.defaultLayout? parent.width - width : 0
                    transformOrigin: View.defaultLayout? Menu.TopRight : Menu.TopLeft
                    modal: true

                    onVisibleChanged: {
                        if(visible)
                            BackHandler.pushHandler(optionsMenu, function(){visible = false})
                        else
                            BackHandler.removeHandler(optionsMenu)
                    }

                    MenuItem {
                        text: localFavorited? qsTr("Unfavorite") : qsTr("Favorite")
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 9*Devices.fontDensity
                        onTriggered: {
                            if(!selectMode) {
                                poem_header.favorited = !poem_header.favorited
                            } else {
                                var keys = selectionHash.keys()
                                for(var i=0; i<selectionHash.count; i++) {
                                    var vid = keys[i]
                                    if( localFavorited ) {
                                        UserData.unfavorite(poemId,vid)
                                    } else {
                                        UserData.favorite(poemId,vid)
                                    }
                                }
                                if(localFavorited)
                                    showTooltip( qsTr("Unfavorited") )
                                else
                                    showTooltip( qsTr("Favorited") )
                            }
                            selectMode = false
                        }

                        property bool localFavorited: {
                            if(!selectMode) {
                                return poem_header.favorited
                            } else {
                                var keys = selectionHash.keys()
                                var favoriteds = 0
                                var unfavoriteds = 0
                                for(var i=0; i<selectionHash.count; i++) {
                                    var vid = keys[i]
                                    var faved = UserData.isFavorited(poemId, vid)
                                    if(faved)
                                        favoriteds++
                                    else
                                        unfavoriteds++
                                }
                                return favoriteds > unfavoriteds
                            }
                        }
                    }
                    MenuItem {
                        text: selectMode? qsTr("Cancel Select") : qsTr("Select")
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 9*Devices.fontDensity
                        onTriggered: selectMode = !selectMode
                    }
                    MenuItem {
                        text: qsTr("Share Image")
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 9*Devices.fontDensity
                        enabled: selectMode
                        onTriggered: {
                            var poet
                            var catId = Database.poemCat(poem_header.poemId)
                            while( catId ) {
                                poet = Database.catName(catId)
                                catId = Database.parentOf(catId)
                            }

                            networkFeatures.pushAction( ("Share Image: %1").arg(poem_header.poemId) )
                            stickerDialog = sticker_dialog_component.createObject(view)
                            stickerDialog.text = getPoemText(false)
                            stickerDialog.poet = poet
                        }
                    }
                    MenuItem {
                        text: qsTr("Share")
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 9*Devices.fontDensity
                        onTriggered: {
                            networkFeatures.pushAction( ("Share Poem: %1").arg(poem_header.poemId) )
                            var subject = Database.poemName(poem_header.poemId)
                            var catId = Database.poemCat(poem_header.poemId)
                            while( catId ) {
                                subject = Database.catName(catId) + ", " + subject
                                catId = Database.parentOf(catId)
                            }

                            var message = getPoemText(true)
                            Devices.share(subject,message)
                        }
                    }
                    MenuItem {
                        text: qsTr("Copy")
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 9*Devices.fontDensity
                        onTriggered: {
                            networkFeatures.pushAction( ("Copy Poem: %1").arg(poem_header.poemId) )
                            var message = getPoemText(true)
                            Devices.clipboard = message
                            showTooltip(qsTr("Copied..."))
                        }
                    }
//                    MenuItem {
//                        text: qsTr("Compare")
//                        font.family: AsemanApp.globalFont.family
//                        font.pixelSize: 9*Devices.fontDensity
//                        onTriggered: showSidePoem(poem_header.poemId)
//                    }
                }
            }
        }
    }

    function getPoemText(poetName) {
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
            if(selectMode)
            {
                if(selectionHash.contains(vid))
                    message += selectionHash.value(vid) + "\n"
                continue
            }

            if( i!=0 && Database.versePosition(poem_header.poemId,vid)===0 && Database.versePosition(poem_header.poemId,vid+1)===1 )
                message = message + "\n"

            message = message + Database.verseText(poem_header.poemId,vorders[i]) + "\n"

        }

        if(poetName)
            message += "\n\n" + poet
        if(selectMode)
            selectMode = false

        return message.trim()
    }

    function showMenu() {
        optionsMenu.open()
    }
}
