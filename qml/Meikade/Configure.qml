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

BackHandlerView {
    id: configure
    width: 100
    height: 62
    color: "#f0f0f0"

    viewMode: false

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: "#40CCC3"
        z: 2

        Item {
            anchors.fill: parent
            anchors.topMargin: View.statusBarHeight

            Button{
                id: back_btn
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                radius: 0
                normalColor: "#00000000"
                highlightColor: "#33666666"
                textColor: "#ffffff"
                iconHeight: 16*Devices.density
                fontSize: 11*globalFontDensity*Devices.fontDensity
                textFont.bold: false
                visible: backButton
                onClicked: {
                    AsemanApp.back()
                    Devices.hideKeyboard()
                }

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 25*globalFontDensity*Devices.fontDensity
                    font.family: awesome_font.name
                    color: "white"
                    text: ""
                }
            }

            Text {
                id: configure_txt
                anchors.centerIn: parent
                height: headerHeight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#ffffff"
            }
        }

        TitleBarShadow {
            width: parent.width
            anchors.top: parent.bottom
        }
    }

    Item {
        id: frame
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        clip: true

        Rectangle {
            id: perf_frame
            width: parent.width
            height: parent.height
            color: configure.color
            transformOrigin: Item.Center
            scale: configure.viewMode? 0.85 : 1.0

            Behavior on scale {
                NumberAnimation { easing.type: Easing.OutCubic; duration: animations*300 }
            }

            ListView {
                id: prefrences
                anchors.fill: parent
                anchors.topMargin: 4*Devices.density
                anchors.bottomMargin: 4*Devices.density
                highlightMoveDuration: 250
                maximumFlickVelocity: View.flickVelocity
                boundsBehavior: Flickable.StopAtBounds
                rebound: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        duration: 0
                    }
                }
                clip: true

                model: ListModel {}
                delegate: Rectangle {
                    id: item
                    width: prefrences.width
                    height: txt.height + 20*Devices.density
                    color: press? "#880d80ec" : "#00000000"

                    property string dstFile: file
                    property alias press: marea.pressed
                    property bool checkable: check

                    property string prprt: pr

                    Text{
                        id: txt
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: 30*Devices.density
                        anchors.leftMargin: Meikade.languageDirection == Qt.RightToLeft? 30*Devices.density + checkbox.width : 30*Devices.density
                        anchors.rightMargin: Meikade.languageDirection != Qt.RightToLeft? 30*Devices.density + checkbox.width : 30*Devices.density
                        y: parent.height/2 - height/2
                        font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                        font.family: AsemanApp.globalFont.family
                        color: "#333333"
                        text: name
                        wrapMode: TextInput.WordWrap
                    }

                    MouseArea {
                        id: marea
                        anchors.fill: parent
                        onClicked: {
                            if( !item.checkable ) {
                                var component = Qt.createComponent(item.dstFile)
                                var citem = component.createObject(sub_frame)
                                sub_frame.item = citem
                                configure.viewMode = true
                            } else {
                                checkbox.checked = !checkbox.checked
                                networkFeatures.pushAction( ("Configure: %1 changed to %2").arg(item.prprt).arg(checkbox.checked) )
                            }
                        }
                    }

                    CheckBox {
                        id: checkbox
                        x: Meikade.languageDirection == Qt.RightToLeft? 20 : item.width - width - 20
                        anchors.verticalCenter: parent.verticalCenter
                        visible: item.checkable
                        color: "#333333"
                        checked: item.prprt.length==0? false : Meikade.property(Meikade,item.prprt)
                        onCheckedChanged: Meikade.setProperty(Meikade,item.prprt,checked)
                    }
                }

                highlight: Rectangle { color: "#880d80ec"; radius: 3; smooth: true }
                currentIndex: -1

                function refresh() {
                    model.clear()

                    model.append({ "name": qsTr("Backup & Restore"), "file": "BackupDialog.qml", "check": false, "pr":""})
//                    model.append({ "name": qsTr("Fonts"), "file": "FontDialog.qml", "check": false, "pr":""})
//                    model.append({ "name": qsTr("Animations"), "file": "", "check": true, "pr":"animations"})
                    model.append({ "name": qsTr("Languages"), "file": "LanguageSelector.qml", "check": false, "pr":""})
                    model.append({ "name": qsTr("Night Theme"), "file": "", "check": true, "pr":"nightTheme"})
                    model.append({ "name": qsTr("Phrase"), "file": "", "check": true, "pr":"phrase"})
                    if(Devices.isAndroid)
                        model.append({ "name": qsTr("Keep screen on"), "file": "", "check": true, "pr":"keepScreenOn"})
                    model.append({ "name": qsTr("Send anonymous data to improve meikade."), "file": "", "check": true, "pr":"activePush"})
                }
            }

            ScrollBar {
                scrollArea: prefrences; height: prefrences.height
                anchors.right: prefrences.right; anchors.top: prefrences.top; color: "#ffffff"
            }
        }

        Rectangle {
            id: black
            anchors.fill: parent
            color: "#000000"
            opacity: (1 - perf_frame.scale)*3
        }

        Rectangle {
            id: sub_frame
            width: parent.width
            height: parent.height
            x: configure.viewMode? 0 : parent.width
            color: configure.color
            visible: x != parent.width

            property variant item

            onVisibleChanged: {
                if( visible )
                    return
                if( !item )
                    return

                item.destroy()
            }

            Behavior on x {
                NumberAnimation { easing.type: Easing.OutCubic; duration: animations*300 }
            }
            Behavior on scale {
                NumberAnimation { easing.type: Easing.OutCubic; duration: animations*300 }
            }
        }
    }

    Connections{
        target: Meikade
        onCurrentLanguageChanged: initTranslations()
    }

    function initTranslations(){
        prefrences.refresh()
    }

    Component.onCompleted: {
        initTranslations()
    }

    ActivityAnalizer { object: configure; comment: "" }
}
