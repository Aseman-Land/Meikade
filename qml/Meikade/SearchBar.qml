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
import QtQuick.Controls 1.0 as QtControls

BackHandlerView {
    id: search_bar
    width: 100
    color: Meikade.nightTheme? "#222222" : "#ffffff"
    viewMode: false
    clip: true

    property bool hide: true
    property bool searchMode: false
    property real headerRightMargin: 0

    onHideChanged: {
        if( !hide )
            txt.focus = true
        else
            main.focus = true

        txt.text = ""
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
                anchors.margins: 11*Devices.density
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
                inputMethodHints: Qt.ImhNoPredictiveText
                color: "#dddddd"
                font.family: AsemanApp.globalFont.family
                font.pixelSize: Devices.fontDensity*11
                onTextChanged: refresh()

                QtControls.ComboBox {
                    id: poets_combo
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width/4
                    textRole: "text"
                    model: ListModel{
                        id: poets_model
                    }
                    onCurrentIndexChanged: txt.refresh()

                    Connections {
                        target: Database
                        onPoetsChanged: refresh()
                        onInitializeFinished: refresh()

                        function refresh(){
                            poets_combo.model.clear()
                            poets_model.append({"text": qsTr("All Poets"), "pid": -1})

                            var poets = Database.poets()
                            for(var i=0; i<poets.length; i++) {
                                var pid = poets[i]
                                poets_model.append({"text": Database.catName(pid), "pid": pid})
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.fill: poets_combo
                    color: search_frame.color

                    Text {
                        anchors.fill: parent
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WrapAnywhere
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: "#ffffff"
                        text: poets_combo.currentText
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 1*Devices.density
                        color: "#888888"
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

    PoemView {
        id: poem
        anchors.top: search_frame.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        clip: true
        x: search_bar.viewMode? 0 : -width
        rememberBar: true

        Behavior on x {
            NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
        }
    }

    SearchList {
        id: search_list
        anchors.top: search_frame.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        x: search_bar.viewMode? width : 0
        keyword: txt.text
        clip: true
        poetId: {
            var obj = poets_combo.model.get(poets_combo.currentIndex)
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
    }
}
