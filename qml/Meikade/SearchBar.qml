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
import QtQuick.Controls 2.0 as QtControls

BackHandlerView {
    id: search_bar
    width: 100
    color: Meikade.nightTheme? "#222222" : "#dddddd"
    viewMode: false
    clip: true

    property bool hide: true
    property bool searchMode: false
    property real headerRightMargin: 0

    onHideChanged: {
        if( !hide )
            txt.focus = true

        txt.text = ""
        search_list.poetCombo.currentIndex = 0
    }

    Rectangle {
        id: search_frame
        width: parent.width
        height: Devices.standardTitleBarHeight + View.statusBarHeight
        color: "#440B0B"

        Item {
            y: Devices.standardTitleBarHeight/2 - height/2 + View.statusBarHeight
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: headerRightMargin
            height: 42*Devices.density

            Image {
                id: search_img
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.topMargin: 11*Devices.density
                anchors.bottomMargin: 11*Devices.density
                width: height
                sourceSize: Qt.size(width,height)
                source: "icons/search.png"
                mirror: true
            }

            Rectangle {
                id: search_splitter
                width: 1*Devices.density
                height: parent.height/2
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: search_img.left
                anchors.margins: txt.anchors.rightMargin/2
                color: "#888888"
            }

            Text {
                id: placeholder
                anchors.fill: txt
                font: txt.font
                color: "#888888"
                text: qsTr("Search")
                visible: !txt.focus && txt.text.length == 0
            }

            TextInput {
                id: txt
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: search_img.left
                anchors.left: parent.left
                anchors.margins: 4*Devices.density
                anchors.topMargin: anchors.margins+1*Devices.density
                anchors.rightMargin: 20*Devices.density
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                inputMethodHints: {
                    var deviceName = Devices.deviceName
                    if(deviceName.toLowerCase().indexOf("htc") >= 0)
                        return Qt.ImhNone
                    else
                        return Qt.ImhNoPredictiveText
                }
                color: "#dddddd"
                font.family: AsemanApp.globalFont.family
                font.pixelSize: Devices.fontDensity*11
                onTextChanged: refresh()

                Button {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 4*Devices.density
                    height: parent.height
                    width: height
                    normalColor: "#00000000"
                    highlightColor: "#44ffffff"
                    iconHeight: height*0.6
                    radius: 3*Devices.density
                    icon: "icons/button-close.png"
                    visible: txt.text.length != 0
                    onClicked: txt.text = ""
                }

                function refresh() {
                    if( text.length == 0 ) {
                        search_bar.searchMode = false
                        search_starter.stop()
                    } else {
                        search_starter.restart()
                    }
                }
            }

            Timer {
                id: search_starter
                interval: 500
                repeat: false
                onTriggered: search_bar.searchMode = true
            }
        }
    }

    SearchList {
        id: search_list
        anchors.top: search_frame.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: portrait? parent.width : parent.width*1/3
        keyword: txt.text
        clip: true
        poetId: {
            var obj = search_list.poetCombo.model.get(search_list.poetCombo.currentIndex)
            if(!obj)
                return -1
            if(obj.pid == -1)
                return -1

            return Database.catPoetId(obj.pid)
        }

        Behavior on x {
            NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
        }

        onItemSelected: {
            poem.poemId = poem_id
            poem.goTo(vid)
            poem.highlightItem(vid)
            search_bar.viewMode = true
        }

        Rectangle{
            y: -height
            width: parent.height
            height: 10*Devices.density
            rotation: 90
            transformOrigin: Item.BottomLeft
            visible: !portrait
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 1.0; color: "#33000000" }
            }
        }
    }

    PoemView {
        id: poem
        anchors.top: search_frame.bottom
        anchors.bottom: parent.bottom
        width: portrait? parent.width : parent.width*2/3
        clip: true
        x: search_bar.viewMode? 0 : -width
        rememberBar: true

        Behavior on x {
            NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
        }
    }

    TitleBarShadow {
        width: parent.width
        anchors.top: search_frame.bottom
    }

    Button{
        id: back_btn
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: View.statusBarHeight
        height: headerHeight
        radius: 0
        normalColor: "#00000000"
        highlightColor: "#88666666"
        textColor: "#ffffff"
        icon: "icons/back_light_64.png"
        iconHeight: 16*Devices.density
        fontSize: 11*globalFontDensity*Devices.fontDensity
        textFont.bold: false
        visible: backButton && search_bar.searchMode
        onClicked: {
            AsemanApp.back()
            Devices.hideKeyboard()
        }
    }

    function show() {
        hide = false
        main.mainTitle = ""
    }
}
