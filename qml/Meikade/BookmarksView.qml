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

import QtQuick 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import AsemanTools 1.0
import "globals"

Rectangle {
    id: bview

    color: MeikadeGlobals.backgroundAlternativeColor

    property alias header: bview_list.header
    property alias count: bview_list.count

    property real fontScale: Meikade.fontPointScale(Meikade.poemsFont)
    property bool editable: true
    property bool headerVisible: true

    signal itemSelected(int pid, int vid)

    AsemanListView {
        id: bview_list
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 250
        displayMarginBeginning: 512*Devices.density
        displayMarginEnd: 512*Devices.density
        cacheBuffer: 512*Devices.density
        bottomMargin: View.navigationBarHeight
        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: height/2
        preferredHighlightEnd: height/2

        model: ListModel {}
        delegate: Rectangle {
            id: item
            width: bview_list.width
            height: book.height + poem.height + address.height - 5*Devices.density
            color: bview.color

            Rectangle {
                id: book
                anchors.top: parent.top
                anchors.topMargin: 8*Devices.density
                width: parent.width
                height: book_txt.height
                color: bview.color

                Text {
                    id: book_txt
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 8*Devices.density
                    width: parent.width - 15*Devices.density
                    font.pixelSize: Devices.isMobile? 8*globalFontDensity*Devices.fontDensity : 9*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: Meikade.nightTheme? Qt.darker(MeikadeGlobals.foregroundColor) : Qt.darker(MeikadeGlobals.backgroundColor)
                    wrapMode: Text.WordWrap
                    maximumLineCount: 1
                    elide: Text.ElideRight

                    Component.onCompleted: {
                        text = Database.poemName(poem.pid)
                    }
                }
            }

            PoemItem {
                id: poem
                anchors.bottom: address.top
                width: parent.width
                color: "transparent"
                textColor: MeikadeGlobals.foregroundColor
                vid: verseId == 0? 1 : verseId
                pid: poemId
                font.pixelSize: Devices.isMobile? 9*globalFontDensity*Devices.fontDensity : 10*globalFontDensity*Devices.fontDensity
            }

            Rectangle {
                id: address
                anchors.bottom: parent.bottom
                width: parent.width
                height: address_txt.height
                color: Qt.lighter(MeikadeGlobals.masterColor)

                Text {
                    id: address_txt
                    anchors.bottom: parent.bottom
                    x: parent.width - width - 8*Devices.density
                    font.pixelSize: Devices.isMobile? 8*globalFontDensity*Devices.fontDensity : 9*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: "#ffffff"

                    Component.onCompleted: {
                        var cat = Database.poemCat(poem.pid)
                        var str = Database.catName(cat)

                        var poet
                        var book
                        while( cat ) {
                            book = poet
                            poet = cat
                            cat = Database.parentOf(cat)
                        }

                        var bname = Database.catName(book)
                        if(bname != str)
                            str = bname + qsTr(", ") + str

                        str = Database.catName(poet) + qsTr(", ") + str
                        text = str
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    width: verse_txt.width + 20*Devices.density
                    height: parent.height
                    color: MeikadeGlobals.masterColor
                    visible: verseId != 0

                    Text {
                        id: verse_txt
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: Devices.isMobile? 8*globalFontDensity*Devices.fontDensity : 9*globalFontDensity*Devices.fontDensity
                        font.family: AsemanApp.globalFont.family
                        color: "#ffffff"
                        text: qsTr("Verse")
                    }
                }
            }

            ItemDelegate {
                id: marea
                anchors.fill: parent
                onClicked: {
                    itemSelected(poemId, verseId)
                }
            }
        }

        ScrollBar {
            scrollArea: bview_list; height: bview_list.height
            anchors.right: bview_list.right; anchors.top: bview_list.top
            LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
        }

        GoUpButton { list: bview_list; visible: false }
    }

    function add(poem_id, verse_id) {
        bview_list.model.append({"poemId": poem_id, "verseId": verse_id})
    }

    function clear() {
        bview_list.model.clear()
    }
}
