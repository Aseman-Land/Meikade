/*
    Copyright (C) 2014 Aseman Labs
    http://labs.aseman.org

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
    id: hafez_omen
    width: 100
    height: 62

    property alias catId: omen_frame.catId
    property alias cellulSize: omen_frame.cellulSize
    property bool viewMode: false

    property int duration: 400
    property int easingType: Easing.OutQuad

    onViewModeChanged: {
        if( !viewMode )
            omen_frame.refresh()
        if( viewMode )
            BackHandler.pushHandler(hafez_omen, hafez_omen.back)
        else
            BackHandler.removeHandler(hafez_omen)
    }

    Image {
        anchors.fill: parent
        source: "icons/hafez_omen.jpg"
        fillMode: Image.PreserveAspectCrop

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30*Devices.density + View.navigationBarHeight
            height: intent_txt.height + 20*Devices.density
            color: "#bb000000"

            Text {
                id: intent_txt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 11*Devices.fontDensity
                wrapMode: Text.WordWrap
                color: "#ffffff"
                text: qsTr("Intent and Tap on the screen")
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    OmenFrame {
        id: omen_frame
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        scale: hafez_omen.viewMode && portrait? 0.8 : 1
        onItemSelected: {
            if( !hafez_omen.viewMode )
                hafez_omen.switchPages()
            view.poemId = pid
            view.goToBegin()
        }

        Behavior on scale {
            NumberAnimation { easing.type: hafez_omen.easingType; duration: animations*hafez_omen.duration }
        }
    }

    Rectangle {
        id: black
        anchors.fill: parent
        color: "#000000"
        opacity: (1 - omen_frame.scale)*3
    }

    PoemView {
        id: view
        width: portrait? parent.width : parent.width*2/3
        height: parent.height
        x: hafez_omen.viewMode? 0 : -width - shadow.width

        Behavior on x {
            NumberAnimation { easing.type: hafez_omen.easingType; duration: animations*hafez_omen.duration }
        }

        Rectangle{
            id: shadow
            x: parent.width
            y: -height
            width: parent.height
            height: 10*Devices.density
            rotation: 90
            transformOrigin: Item.BottomLeft
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 1.0; color: "#33000000" }
            }
        }
    }

    function switchPages() {
        hafez_omen.viewMode = !hafez_omen.viewMode
    }

    function back() {
        hafez_omen.viewMode = false
    }
}
