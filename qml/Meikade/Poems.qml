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
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import AsemanQml.Base 2.0
import AsemanQml.Awesome 2.0
import "globals"

Rectangle {
    id: poems
    color: MeikadeGlobals.backgroundColor

    property int catId: -1

    onCatIdChanged: {
        poems_list.refresh()

        var fileName = catId
        var filePath = "banners/" + fileName + ".jpg"
        while( !Meikade.fileExists(filePath) ) {
            fileName = Database.parentOf(fileName)
            filePath = "banners/" + fileName + ".jpg"
        }

        var result = filePath
        img.source = result
    }

    signal itemSelected( int pid )

    Item {
        id: header_back
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: View.statusBarHeight+42*Devices.density
        clip: true

        Image {
            id: img
            anchors.left: parent.left
            anchors.right: parent.right
            y: 0
            height: sourceSize.height*width/sourceSize.width
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        FastBlur {
            id: blur
            anchors.fill: img
            source: img
            radius: 64
            Component.onDestruction: radius = 0
        }

        Rectangle {
            anchors.fill: blur
            color: "#000000"
            opacity: 0.4
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: View.defaultLayout? undefined : parent.right
            anchors.left: View.defaultLayout? parent.left : undefined
            anchors.margins: 8*Devices.density
            color: "#ffffff"
            font.pixelSize: 10*globalFontDensity*Devices.fontDensity
            horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
            font.family: AsemanApp.globalFont.family
            text: Database.catName(catId)
        }

        Button{
            id: rand_btn
            anchors.right: View.defaultLayout? parent.right : undefined
            anchors.left: View.defaultLayout? undefined : parent.left
            anchors.margins: 8*Devices.density
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            radius: 0
            normalColor: "transparent"
            highlightColor: "#22000000"
            iconHeight: 25*Devices.density
            visible: true
            onClicked: {
                showRandomPoem(catId)
            }

            Text {
                anchors.centerIn: parent
                font.pixelSize: 13*globalFontDensity*Devices.fontDensity
                font.family: Awesome.family
                color: "white"
                text: Awesome.fa_random
            }
        }
    }

    AsemanListView {
        id: poems_list
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header_back.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4*Devices.density
        highlightMoveDuration: 250
        spacing: 8*Devices.density
        topMargin: spacing
        bottomMargin: View.navigationBarHeight + spacing
        clip: true
        model: ListModel {}
        delegate: ItemPane {
            id: item
            x: poems_list.spacing
            width: poems_list.width - 2*x
            height: txt.height + 30*Devices.density

            property int pid: identifier
            property bool hasFavorite: false
            property bool hasNote: false

            onPidChanged: {
                txt.poemTitle = Database.poemName(pid)
                txt.poemFristVerse = Database.verseText(pid, 1)
            }

            Text {
                id: txt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 30*Devices.density
                y: parent.height/2 - height/2
                font.pixelSize: Devices.isMobile? 9*globalFontDensity*Devices.fontDensity : 10*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                color: MeikadeGlobals.foregroundColor
                text: {
                    if(Meikade.endUsingNumber(poemTitle))
                        return poemTitle + " - " + poemFristVerse + "..."
                    else
                        return poemTitle
                }
                wrapMode: Text.WordWrap
                maximumLineCount: 1
                elide: Text.ElideRight

                property string poemTitle: Database.poemName(pid)
                property string poemFristVerse: Database.verseText(pid, 1)
            }

            ItemDelegate {
                id: marea
                anchors.fill: parent
                onClicked: {
                    poems.itemSelected(item.pid)
                }
            }
        }

        focus: true
        highlight: Rectangle { color: Meikade.nightTheme? "#12223D" : "#3B97EC"; radius: 3; smooth: true }
        currentIndex: -1

        function refresh() {
            model.clear()

            var poems = Database.catPoems(catId)
            for( var i=0; i<poems.length; i++ )
                model.append({"identifier": poems[i]})

            focus = true
        }
    }

    TitleBarShadow {
        width: parent.width
        anchors.top: header_back.bottom
        visible: !Devices.isIOS
    }

    ScrollBar {
        scrollArea: poems_list; height: poems_list.height - View.navigationBarHeight
        anchors.right: poems_list.right; anchors.top: poems_list.top
        color: Meikade.nightTheme? "#ffffff" : MeikadeGlobals.masterColor
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }
}
