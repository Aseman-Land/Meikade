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
import AsemanTools.Awesome 1.0

BackHandlerView {
    id: search_bar
    anchors.fill: parent
    color: Meikade.nightTheme? "#222222" : "#dddddd"
    viewMode: false
    clip: true

    property bool hide: true
    property bool searchMode: false
    property real headerRightMargin: menu_button.width

    readonly property string title: " "

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
            anchors.rightMargin: View.layoutDirection==Qt.LeftToRight? 0 : headerRightMargin
            anchors.leftMargin: View.layoutDirection==Qt.LeftToRight? headerRightMargin : 0
            height: 42*Devices.density

            Text {
                id: search_img
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: View.layoutDirection==Qt.LeftToRight? undefined : parent.right
                anchors.left: View.layoutDirection==Qt.LeftToRight? parent.left : undefined
                anchors.topMargin: 11*Devices.density
                anchors.bottomMargin: 11*Devices.density
                font.pixelSize: 15*globalFontDensity*Devices.fontDensity
                font.family: Awesome.family
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                text: Awesome.fa_search
            }

            Rectangle {
                id: search_splitter
                width: 1*Devices.density
                height: parent.height/2
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: View.layoutDirection==Qt.LeftToRight? undefined : search_img.left
                anchors.left: View.layoutDirection==Qt.LeftToRight? search_img.right : undefined
                anchors.margins: 10*Devices.density
                color: "#888888"
            }

            Text {
                id: placeholder
                anchors.fill: txt
                font: txt.font
                color: "#888888"
                text: qsTr("Search")
                verticalAlignment: Text.AlignVCenter
                visible: !txt.focus && txt.text.length == 0
            }

            TextInput {
                id: txt
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: View.layoutDirection==Qt.LeftToRight? parent.right : search_img.left
                anchors.left: View.layoutDirection==Qt.LeftToRight? search_img.right : parent.left
                anchors.margins: 4*Devices.density
                anchors.topMargin: anchors.margins+1*Devices.density
                anchors.rightMargin: View.layoutDirection==Qt.LeftToRight? anchors.margins : 20*Devices.density
                anchors.leftMargin: View.layoutDirection==Qt.LeftToRight? 20*Devices.density : anchors.margins
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: View.layoutDirection==Qt.LeftToRight? Text.AlignLeft : Text.AlignRight
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
                    anchors.top: parent.top
                    x: View.layoutDirection==Qt.LeftToRight? parent.width - width - 4*Devices.density : 4*Devices.density
                    height: parent.height
                    width: height
                    normalColor: "#00000000"
                    highlightColor: "#44ffffff"
                    iconHeight: height*0.6
                    radius: 3*Devices.density
                    visible: txt.text.length != 0
                    onClicked: txt.text = ""

                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 14*globalFontDensity*Devices.fontDensity
                        font.family: Awesome.family
                        color: "#99ffffff"
                        text: Awesome.fa_close
                    }
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
        anchors.right: View.layoutDirection==Qt.LeftToRight? undefined : parent.right
        anchors.left: View.layoutDirection==Qt.LeftToRight? parent.left : undefined
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

        onItemSelected: {
            poem.poemId = poem_id
            poem.goTo(vid)
            poem.highlightItem(vid)
            search_bar.viewMode = true
        }

        Rectangle{
            y: View.layoutDirection==Qt.LeftToRight? parent.height-height : -height
            x: View.layoutDirection==Qt.LeftToRight? parent.width : 0
            width: parent.height
            height: 3*Devices.density
            rotation: View.layoutDirection==Qt.LeftToRight? -90 : 90
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
        x: {
            switch(View.layoutDirection) {
            case Qt.RightToLeft:
                return  search_bar.viewMode? 0 : -width
            default:
            case Qt.LeftToRight:
                return  search_bar.viewMode? parent.width - width : parent.width
            }
        }
        rememberBar: true

        Behavior on x {
            NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
        }
    }

    TitleBarShadow {
        width: parent.width
        anchors.top: search_frame.bottom
    }

    function show() {
        hide = false
    }
}
