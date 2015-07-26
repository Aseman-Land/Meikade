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
    id: poem_edit
    width: 100
    height: 62
    color: "#363636"

    property int vid
    property int poemId
    property bool actived: false
    property variant currentItem
    property real destOpacity: 1
    property bool favorited: false
    property string text

    property alias press: note.press

    onVidChanged: {
        if( vid == -1 )
            return
        privates.signalBlocker = true
        note.text = UserData.note(poemId,vid)
        favorited = UserData.isFavorited(poemId,vid)
        privates.signalBlocker = false
    }

    onPoemIdChanged: {
        var name = Database.poemName(poemId)
        var catId = Database.poemCat(poemId)
        while( catId ) {
            name = Database.catName(catId) + ", " + name
            catId = Database.parentOf(catId)
        }
    }

    onFavoritedChanged: {
        if( privates.signalBlocker )
            return
        if( favorited ) {
            UserData.favorite(poemId,vid)
            main.showTooltip( qsTr("Favorited") )
        } else {
            UserData.unfavorite(poemId,vid)
            main.showTooltip( qsTr("Unfavorited") )
        }
    }

    QtObject {
        id: privates
        property bool signalBlocker: false
    }

    Row {
        id: row
        anchors.fill: parent

        Column {
            id: tools_column
            height: parent.height
            width: 42*Devices.density

            Button {
                id: paste
                height: width
                width: parent.width
                icon: "icons/paste.png"
                iconHeight: 18*Devices.density
                normalColor: "#904F73"
                highlightColor: "#EC4334"
                onClicked: note.paste()
            }

            Button {
                id: copy
                height: width
                width: parent.width
                icon: "icons/copy.png"
                iconHeight: 18*Devices.density
                normalColor: "#4774A7"
                highlightColor: "#EC4334"
                onClicked: note.copy()
            }
        }

        Item {
            id: note_back
            width: row.width - tools_column.width - share_column.width
            height: row.height

            TextEdit {
                id: note_placeholder
                anchors.fill: note
                font: note.font
                color: "#cccccc"
                visible: note.text.length == 0
            }

            TextAreaCore {
                id: note
                anchors.fill: parent
                anchors.margins: 4*Devices.density
                font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                wrapMode: Text.Wrap
                selectionColor: "#0d80ec"
                selectedTextColor: "#ffffff"
                color: "#ffffff"
                pickersColor: "#cccccc"
                pickersStrokeColor: "#ffffff"
                inputMethodHints: Qt.ImhNoPredictiveText
                horizontalAlignment: Meikade.languageDirection == Qt.LeftToRight? Text.AlignLeft : Text.AlignRight

                onTextChanged: {
                    save_timer.restart()
                }

                Timer{
                    id: save_timer
                    interval: 500*animations
                    repeat: false
                    onTriggered: UserData.setNote(poem_edit.poemId,poem_edit.vid, note.text)
                }
            }
        }

        Column {
            id: share_column
            height: parent.height
            width: 42*Devices.density

            Button {
                id: favorite
                height: width
                width: parent.width
                icon: poem_edit.favorited? "icons/favorites.png" : "icons/unfavorites.png"
                iconHeight: 18*Devices.density
                normalColor: "#A79B48"
                highlightColor: "#EC4334"
                onClicked: poem_edit.favorited = !poem_edit.favorited
            }

            Button {
                id: share
                height: width
                width: parent.width
                icon: "icons/share.png"
                iconHeight: 18*Devices.density
                normalColor: "#4F9082"
                highlightColor: "#EC4334"
                onClicked: {
                    var subject = Database.poemName(poem_edit.poemId)
                    var poet
                    var catId = Database.poemCat(poem_edit.poemId)
                    while( catId ) {
                        poet = Database.catName(catId)
                        subject = Database.catName(catId) + ", " + subject
                        catId = Database.parentOf(catId)
                    }

                    var message = poem_edit.text + "\n\n" + poet
                    Devices.share(subject,message)
                }
            }
        }
    }

    function refresh(){
        var tmp = poem_edit.vid
        poem_edit.vid = -1
        poem_edit.vid = tmp
    }

    function hidePicker() {
        note.hidePicker()
    }


    Connections{
        target: Meikade
        onCurrentLanguageChanged: initTranslations()
    }

    function initTranslations(){
        note_placeholder.text = qsTr("Note...")
    }
    Component.onCompleted: initTranslations()
}
