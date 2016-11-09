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
    id: hafez_omen
    width: 100
    height: 62
    color: "#000000"

    property alias catId: omen_frame.catId
    property alias cellulSize: omen_frame.cellulSize
    property bool viewMode: false
    property bool description: false

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

    onDescriptionChanged: {
        if(description)
            BackHandler.pushHandler(hafez_omen_desc, hafez_omen_desc.back)
        else
            BackHandler.removeHandler(hafez_omen_desc)
    }

    Item {
        id: homen_scene
        anchors.fill: parent
        scale: description? 0.7 : 1
        transformOrigin: Item.Bottom

        Behavior on scale {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 400 }
        }

        Image {
            anchors.fill: parent
            source: "icons/hafez_omen.jpg"
            fillMode: Image.PreserveAspectCrop
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
                var animationsRecovery = animations
                animations = false
                view.viewMode = true
                animations = animationsRecovery
                BackHandler.removeHandler(view)
            }

            Behavior on scale {
                NumberAnimation { easing.type: hafez_omen.easingType; duration: animations*hafez_omen.duration }
            }
        }

        Item {
            anchors.fill: parent

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: intent_txt.height + 20*Devices.density
                color: "#bb000000"

                Text {
                    id: intent_txt
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 11*globalFontDensity*Devices.fontDensity
                    wrapMode: Text.WordWrap
                    color: "#ffffff"
                    text: qsTr("Intent and Tap on the screen")
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: read_more_column.height + 20*Devices.density + View.navigationBarHeight
                color: "#bb000000"

                Column {
                    id: read_more_column
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 10*Devices.density
                    spacing: 2*Devices.density

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 11*globalFontDensity*Devices.fontDensity
                        wrapMode: Text.WordWrap
                        color: "#ffffff"
                        text: qsTr("Read more about meikade hafez omen")
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Button {
                        anchors.horizontalCenter: parent.horizontalCenter
                        textFont.family: AsemanApp.globalFont.family
                        textFont.pixelSize: 9*globalFontDensity*Devices.fontDensity
                        textFont.bold: false
                        width: 100*Devices.density
                        height: 36*Devices.density
                        radius: 3*Devices.density
                        normalColor: "#0d80ec"
                        highlightColor: Qt.darker(normalColor)
                        textColor: "#ffffff"
                        text: qsTr("Read More")
                        onClicked: description = !description
                    }
                }
            }
        }

        Rectangle {
            id: black
            anchors.fill: parent
            color: "#000000"
            opacity: (1 - omen_frame.scale)*3
        }

        PoemsPage {
            id: view
            height: parent.height
            width: parent.width
            x: hafez_omen.viewMode? 0 : -width - shadow.width
            rememberBar: true

            Behavior on x {
                NumberAnimation { easing.type: hafez_omen.easingType; duration: animations*hafez_omen.duration }
            }

            Rectangle{
                id: shadow
                y: View.layoutDirection==Qt.LeftToRight? parent.height-height : -height
                x: View.layoutDirection==Qt.LeftToRight? parent.width : 0
                width: parent.height
                height: 3*Devices.density
                rotation: View.layoutDirection==Qt.LeftToRight? -90 : 90
                transformOrigin: Item.BottomLeft
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#00000000" }
                    GradientStop { position: 1.0; color: "#33000000" }
                }
            }
        }
    }

    HafezOmenDescription {
        id: hafez_omen_desc
        width: parent.width
        height: parent.height
        y: description? 0 : parent.height

        Behavior on y {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 500 }
        }

        function back() {
            description = false
        }
    }

    function switchPages() {
        hafez_omen.viewMode = !hafez_omen.viewMode
    }

    function back() {
        hafez_omen.viewMode = false
    }

    ActivityAnalizer { object: hafez_omen; comment: "" }
}
