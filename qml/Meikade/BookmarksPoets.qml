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

import QtQuick 2.7
import QtQuick.Controls 2.1
import AsemanTools 1.0
import AsemanTools.Awesome 1.0
import QtQml 2.2
import "globals"

BackHandlerView {
    id: bookmark_poets
    anchors.fill: parent
    clip: true
    color: MeikadeGlobals.backgroundColor
    viewMode: false

    readonly property string title: qsTr("Bookmarks")
    readonly property bool titleBarHide: !forceTitleBarShow && header.hide && (localPortrait || Devices.isMobile)
    property bool forceTitleBarShow: false
    property alias itemsSpacing: category_list.spacing
    property real topMargin: itemsSpacing

    Rectangle {
        id: b_frame
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        color: MeikadeGlobals.backgroundColor

        AsemanListView {
            id: category_list
            anchors.fill: parent
            topMargin: bookmark_poets.topMargin
            bottomMargin: View.navigationBarHeight + spacing
            clip: true
            spacing: 8*Devices.density
            model: ListModel {}
            delegate: Item {
                id: item
                x: category_list.spacing
                width: category_list.width - 2*x
                height: 86*Devices.density

                MaterialFrame {
                    anchors.fill: parent
                    color: MeikadeGlobals.backgroundAlternativeColor
                }
                Column {
                    anchors.fill: parent

                    CategoryItem {
                        width: parent.width
                        height: parent.height - separator.height - stats.height
                        cid: identifier
                        root: true
                    }

                    Rectangle {
                        id: separator
                        width: parent.width
                        height: 1*Devices.density
                        color: MeikadeGlobals.backgroundColor
                    }

                    Row {
                        id: stats
                        layoutDirection: View.layoutDirection
                        rightPadding: 10*Devices.density
                        leftPadding: 10*Devices.density
                        width: parent.width
                        height: 30*Devices.density
                        spacing: 5*Devices.density

                        Text {
                            id: fav_icon
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 15*globalFontDensity*Devices.fontDensity
                            font.family: Awesome.family
                            color: Qt.lighter(MeikadeGlobals.masterColor)
                            text: Meikade.nightTheme? Awesome.fa_heart : Awesome.fa_heart_o
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: View.layoutDirection == Qt.RightToLeft?
                                      Number(pcount).toLocaleString(Qt.locale("fa_IR"), "f", 0) + qsTr(" poem, ") + Number(vcount).toLocaleString(Qt.locale("fa_IR"), "f", 0) + qsTr(" single beit") :
                                      Number(pcount).toLocaleString(Qt.locale("en_EN"), "f", 0) + qsTr(" poem, ") + Number(vcount).toLocaleString(Qt.locale("en_EN"), "f", 0) + qsTr(" single beit")
                            font.pixelSize: Devices.isMobile? 8*globalFontDensity*Devices.fontDensity : 9*globalFontDensity*Devices.fontDensity
                            font.family: AsemanApp.globalFont.family
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            color: Meikade.nightTheme? Qt.darker(MeikadeGlobals.foregroundColor) : Qt.darker(MeikadeGlobals.backgroundColor)
                        }
                    }
                }

                ItemDelegate {
                    id: marea
                    anchors.fill: parent
                    onClicked: {
                        console.log(identifier)
                    }
                }
            }

            HashObject {
                id: poet_poem
            }

            HashObject {
                id: poet_verse
            }

            function refresh() {
                model.clear()
                poet_poem.clear()
                poet_verse.clear()

                var list = UserData.favorites()
                for( var i=0; i<list.length; i++ ) {
                    var sid = list[i]
                    var pid = UserData.extractPoemIdFromStringId(sid)
                    var vid = UserData.extractVerseIdFromStringId(sid)

                    var poet
                    var cat = Database.poemCat(pid)
                    while(cat) {
                        poet = cat
                        cat = Database.parentOf(cat)
                    }

                    var verse_count, poem_count
                    if(vid != 0) {
                        if(poet_verse.contains(poet)) {
                            verse_count = poet_verse.value(poet)
                            verse_count++
                            poet_verse.remove(poet)
                            poet_verse.insert(poet, verse_count)
                        }
                        else {
                            verse_count = 1
                            poem_count = 0
                            poet_verse.insert(poet, verse_count)
                            poet_poem.insert(poet, poem_count)
                        }
                    }
                    else {
                        if(poet_poem.contains(poet)) {
                            poem_count = poet_poem.value(poet)
                            poem_count++
                            poet_poem.remove(poet)
                            poet_poem.insert(poet, poem_count)
                        }
                        else {
                            poem_count = 1
                            verse_count = 0
                            poet_poem.insert(poet, poem_count)
                            poet_verse.insert(poet, verse_count)
                        }
                    }
                }

                var poets = Database.poets()
                for(var j=0; j<poets.length; j++)
                    if(poet_poem.contains(poets[j]) && poet_verse.contains(poets[j]))
                        model.append({"identifier":poets[j],
                                      "pcount":poet_poem.value(poets[j]),
                                      "vcount":poet_verse.value(poets[j])})

                focus = true
            }
        }
    }


    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: MeikadeGlobals.masterColor
        y: titleBarHide? -Devices.standardTitleBarHeight : 0

        property bool hide: false

        Behavior on y {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
        }

        TitleBarShadow {
            width: header.width
            anchors.top: header.bottom
        }
    }

    function refresh() {
        category_list.refresh()
    }

    function hideHeader() {
        header.hide = true
    }

    function showHeader() {
        header.hide = false
    }

    Component.onCompleted: {
        refresh()
        MeikadeGlobals.categoriesList.append(this)
    }
    Component.onDestruction: MeikadeGlobals.categoriesList.removeAll(this)

    ActivityAnalizer { object: bookmark_poets; comment: "" }
}
