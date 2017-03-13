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
import AsemanTools 1.0
import AsemanTools.Awesome 1.0
import "globals"

Rectangle {
    id: cat_item
    width: parent.width
    x: {
        if(outside) {
            if(View.defaultLayout)
                return -parent.width
            else
                return parent.width
        } else {
            return 0
        }
    }
    y: startInit? 0 : startY
    height: startInit? parent.height : startHeight
    clip: true
    color: MeikadeGlobals.backgroundColor

    property alias catId: category.catId
    property alias root: cat_title.root
    property alias list: category.list

    property bool outside: false
    property bool startInit: false

    property real startY: 0
    property real startHeight: 0

    signal categorySelected( int cid, variant rect )
    signal poemSelected( int pid, variant rect )

    Behavior on x {
        NumberAnimation{ easing.type: Easing.OutCubic; duration: destroy_timer.interval }
    }
    Behavior on y {
        NumberAnimation{ easing.type: Easing.OutCubic; duration: destroy_timer.interval }
    }
    Behavior on height {
        NumberAnimation{ easing.type: Easing.OutCubic; duration: destroy_timer.interval }
    }

    Timer {
        id: destroy_timer
        interval: 400
        onTriggered: cat_item.destroy()
    }

    Timer {
        id: start_timer
        interval: 400
        onTriggered: cat_item.startInit = true
    }

    Category {
        id: category
        topMargin: item.visible? item.height : 0
        height: cat_item.parent.height
        width: cat_item.parent.width
        header: root? desc_component : spacer_component
        onCategorySelected: cat_item.categorySelected(cid, rect)
        onPoemSelected: cat_item.poemSelected(pid, rect)
    }

    MaterialFrame {
        id: item
        x: category.itemsSpacing
        width: category.width - 2*x
        height: 55*Devices.density
        opacity: startInit? 0 : 1
        color: MeikadeGlobals.backgroundAlternativeColor
        visible: cat_title.cid != 0

        Behavior on opacity {
            NumberAnimation{ easing.type: Easing.OutCubic; duration: destroy_timer.interval }
        }
    }

    Rectangle {
        height: item.height
        width: parent.width
        color: Qt.rgba(backColor.r, backColor.g, backColor.b, 0.9)
        opacity: startInit? 1 : 0
        visible: cat_title.cid != 0

        property color backColor: MeikadeGlobals.backgroundAlternativeColor

        MouseArea {
            anchors.fill: parent
        }

        Button{
            id: rand_btn
            anchors.right: View.defaultLayout? parent.right : undefined
            anchors.left: View.defaultLayout? undefined : parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            radius: 0
            normalColor: "transparent"
            highlightColor: "#22000000"
            iconHeight: 25*Devices.density
            visible: true
            onClicked: {
                page.showRandomCatPoem(catId)
            }

            Text {
                anchors.centerIn: parent
                font.pixelSize: 13*globalFontDensity*Devices.fontDensity
                font.family: Awesome.family
                color: MeikadeGlobals.foregroundColor
                text: Awesome.fa_random
            }
        }

        Behavior on opacity {
            NumberAnimation{ easing.type: Easing.OutCubic; duration: destroy_timer.interval }
        }

        TitleBarShadow {
            width: parent.width
            anchors.top: parent.bottom
            height: 2*Devices.density
            opacity: 0.4
        }
    }

    CategoryItem {
        id: cat_title
        anchors.fill: item
        cid: category.catId
    }

    Component {
        id: spacer_component
        Item {
            height: category.itemsSpacing
            width: 2
        }
    }

    Component {
        id: desc_component
        Rectangle {
            id: desc_header
            width: cat_item.width
            height: expand? desc_text.height + desc_text.y*2 : 80*Devices.density
            color: "#111111"
            clip: true

            property bool expand: false

            onExpandChanged: {
                if( expand )
                    BackHandler.pushHandler( desc_header, desc_header.unexpand )
                else
                    BackHandler.removeHandler(desc_header)
            }

            Behavior on height {
                NumberAnimation{ easing.type: Easing.OutCubic; duration: 400 }
            }

            Text {
                id: desc_text
                anchors.left: parent.left
                anchors.right: parent.right
                y: 8*Devices.density
                anchors.margins: y
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                color: "#dddddd"
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                text: Database.poetDesctiption(catId)
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 30*Devices.density
                opacity: desc_header.expand? 0 : 1
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#00000000" }
                    GradientStop { position: 1.0; color: desc_header.color }
                }

                Behavior on opacity {
                    NumberAnimation { easing.type: Easing.OutCubic; duration: 400 }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: desc_header.expand = !desc_header.expand
            }

            function unexpand() {
                expand = false
            }
        }
    }

    function start() {
        start_timer.start()
    }

    function end() {
        startInit = false
        destroy_timer.start()
    }

    ActivityAnalizer { object: cat_item; comment: cat_item.catId }
}
