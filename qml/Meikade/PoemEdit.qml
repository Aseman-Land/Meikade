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
import QtQuick.Controls 2.1 as QtControls
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.3
import AsemanTools 1.0
import "globals"

Item {
    id: poemEdit

    property alias vid: poemItem.vid
    property alias pid: poemItem.pid
    property alias textColor: poemItem.textColor

    NullMouseArea { anchors.fill: parent }

    Rectangle {
        id: background
        anchors.fill: parent
        color: MeikadeGlobals.backgroundAlternativeColor
        opacity: 0

        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: poemItem.activeAnim? 400 : 0 }
        }
    }

    QtControls.BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        height: 48*Devices.density
        width: height
        running: false
        transformOrigin: Item.Center
    }

    AsemanFlickable {
        id: flick
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: saveBtn.top
        flickableDirection: Flickable.VerticalFlick
        contentWidth: flickScene.width
        contentHeight: flickScene.height
        clip: true

        function ensureVisible(r)
        {
            var pnt = textArea.mapToItem(flickScene, r.x, r.y)

            if (contentX >= pnt.x)
                contentX = pnt.x;
            else if (contentX+width <= pnt.x+r.width)
                contentX = pnt.x+r.width-width;

            if (contentY >= pnt.y)
                contentY = pnt.y;
            else if (contentY+height <= pnt.y+r.height)
                contentY = pnt.y+r.height-height;
        }

        Item {
            id: flickScene
            width: flick.width
            height: editColumn.y + editColumn.height

            PoemItem {
                id: poemItem
                width: parent.width
                color: "#00000000"
                font.pixelSize: Devices.isMobile? 9*fontScale*globalFontDensity*Devices.fontDensity : 10*fontScale*globalFontDensity*Devices.fontDensity
                font.family: globalPoemFontFamily

                Behavior on y {
                    NumberAnimation { easing.type: Easing.OutCubic; duration: poemItem.activeAnim? 400 : 0 }
                }

                property bool activeAnim: false
            }

            Rectangle {
                id: shadow_rct
                height: 3*Devices.density
                width: parent.width
                y: poemItem.height
                visible: !Devices.isIOS && !busyIndicator.running
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#33000000" }
                    GradientStop { position: 1.0; color: "#00000000" }
                }
            }

            Column {
                id: editColumn
                y: poemItem.height + 10*Devices.density
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10*Devices.density
                visible: !busyIndicator.running

                QtControls.TextArea {
                    id: textArea
                    width: parent.width
                    height: {
                        var min = 150*Devices.density
                        var res = flick.height - poemItem.height - 10*Devices.density
                        if(res < min)
                            res = min

                        var extra = 20*Devices.density
                        if(contentHeight+extra > res)
                            res = contentHeight+extra
                        return res
                    }
                    font.pixelSize: 10*fontScale*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: MeikadeGlobals.foregroundColor
                    selectByMouse: Devices.isDesktop
                    selectedTextColor: "#ffffff"
                    selectionColor: "#03A9F4"
                    placeholderText: qsTr("Write a note about this verse...")
                    wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                    inputMethodHints: {
                        var deviceName = Devices.deviceName.toLowerCase()
                        if(deviceName.indexOf("htc") >= 0 || deviceName.indexOf("huawei") >= 0)
                            return Qt.ImhNone
                        else
                            return Qt.ImhNoPredictiveText
                    }
                    onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)

                    TextCursorArea {
                        textItem: textArea
                        cursorParent: poemEdit
                    }
                }
            }
        }
    }

    QtControls.Button {
        id: saveBtn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10*Devices.density
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Devices.keyboardHeight
        visible: !busyIndicator.running
        highlighted: true
        text: qsTr("Save")
    }

    function start(startY) {
        forceTitleBarShow = true
        busyIndicator.running = true
        poemItem.activeAnim = false
        poemItem.y = startY
        poemItem.activeAnim = true
        poemItem.y = 0
        background.opacity = 1

        Tools.jsDelayCall(2000, function(){ busyIndicator.running = false })
        BackHandler.pushHandler(poemEdit, function() {
            forceTitleBarShow = false
            busyIndicator.running = true
            poemItem.y = startY
            background.opacity = 0
            Tools.jsDelayCall(400, function(){ poemEdit.destroy() })
        })
    }
}
