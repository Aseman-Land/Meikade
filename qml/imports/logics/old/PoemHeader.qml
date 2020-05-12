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
import AsemanQml.Base 2.0
import AsemanQml.Awesome 2.0
import QtQuick.Controls.Material 2.1
import globals 1.0

Item {
    id: poem_header
    width: 100
    height: 190*Devices.density

    property bool favorited: false
    property bool toolsOpened: false
    property alias font: txt1.font
    property color color: "#ffffff"
    property alias busy: busyIndicator.running

    signal nextRequest()
    signal previousRequest()

    QtObject {
        id: privates
        property bool signalBlocker: false
    }

    NullMouseArea { anchors.fill: parent }

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height - header.height

        Button {
            Layout.preferredWidth: 30*Devices.density
            Layout.fillHeight: true
            text: LayoutMirroring.enabled? Awesome.fa_angle_right : Awesome.fa_angle_left
            flat: true
            onClicked: previousRequest()
        }

        Column {
            id: title_column
            Layout.fillWidth: true
            spacing: 10*Devices.density

            Text {
                id: txt1
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 13*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                wrapMode: Text.WordWrap
                color: poem_header.color
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: txt2
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 13*Devices.fontDensity
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
            Layout.preferredWidth: 30*Devices.density
            Layout.fillHeight: true
            text: LayoutMirroring.enabled? Awesome.fa_angle_left : Awesome.fa_angle_right
            flat: true
            onClicked: nextRequest()
        }
    }

    Rectangle {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 32*Devices.density
        color: Qt.lighter(Colors.primary)

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: spacing
            spacing: 4*Devices.density

            Text {
                id: linkText
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 9*Devices.fontDensity
                font.family: Awesome.family
                text: View.defaultLayout? Awesome.fa_chevron_right : Awesome.fa_chevron_left
                color: poem_header.color
            }

            Text {
                id: poet_txt
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 9*Devices.fontDensity
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
                font.pixelSize: 9*Devices.fontDensity
                font.family: Awesome.family
                text: linkText.text
                color: poem_header.color
            }

            Text {
                id: book_txt
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 9*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                wrapMode: TextInput.WordWrap
                color: poem_header.color
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(catId != -1)
                            page.backToCats(catId, poetId)
                    }
                }
            }
        }

        Row {
            id: menu_row
            height: 32*Devices.density
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1*Devices.density

            Button {
                id: menu
                height: menu_row.height
                width: height
                flat: true
                onClicked: optionsMenu.open()

                Rectangle {
                    anchors.centerIn: parent
                    width: selectMode? parent.width : 0
                    height: width
                    color: Colors.primary
                    visible: false

                    Behavior on width {
                        NumberAnimation { easing.type: Easing.OutBack; easing.overshoot: 5*Devices.density; duration: 250 }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 12*Devices.fontDensity
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

                            AsemanServices.meikade.pushAction( ("Share Image: %1").arg(poem_header.poemId), null )
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
                            AsemanServices.meikade.pushAction( ("Share Poem: %1").arg(poem_header.poemId), null )
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
                            AsemanServices.meikade.pushAction( ("Copy Poem: %1").arg(poem_header.poemId), null )
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

            BusyIndicator {
                id: busyIndicator
                anchors.verticalCenter: parent.verticalCenter
                height: 46*Devices.density
                width: height
                running: false
                transformOrigin: Item.Center
                scale: 0.5
                Material.accent: "#ffffff"
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
