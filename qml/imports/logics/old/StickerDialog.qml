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
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1 as QtControls
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import Meikade 1.0
import AsemanQml.Awesome 2.0
import "globals"

Rectangle {
    id: sticker_dialog
    color: "#111111"

    property alias text: txt.text
    property alias poet: poet_txt.text

    property real xratio: 2

    FontLoader{
        source: Meikade.resourcePath + "/fonts/BYekan.ttf"
        onStatusChanged: if(status == FontLoader.Ready) txt.font.family = name
    }

    MouseArea {
        anchors.fill: parent
        onWheel: wheel.accepted = false
    }

    StickerModel {
        id: smodel
        onStateChanged: {
            if(state == StickerModel.Category)
                BackHandler.removeHandler(smodel)
            else
                BackHandler.pushHandler(smodel, smodel.back )
        }

        function back() {
            state = StickerModel.Category
        }
    }

    StickerWriter {
        id: writer
        item: frame
        onSaved: {
            indicator_disabler.restart()
            lastDest = dest
        }

        property string lastDest
    }

    Rectangle {
        id: header
        width: parent.width
        height: Devices.standardTitleBarHeight
        anchors.top: parent.top
        color: Meikade.nightTheme? "#333333" : "#eeeeee"

        Header {
            anchors.fill: parent
            titleFont.pixelSize: 10*globalFontDensity*Devices.fontDensity
            light: Meikade.nightTheme
            backButton: false
            text: qsTr("Share")
            backButtonText: ""
            statusBar: false
            shadow: !MeikadeGlobals.iosStyle
        }

        Row {
            anchors.fill: parent
            anchors.margins: 10*Devices.density
            layoutDirection: View.layoutDirection==Qt.LeftToRight? Qt.RightToLeft : Qt.LeftToRight

            QtControls.Button {
                anchors.verticalCenter: parent.verticalCenter
                width: height*2
                text: qsTr("Save")
                highlighted: true
                onClicked: {
                    indicator.running = true
                    progress_rect.visible = true
                    AsemanServices.meikade.pushAction( ("Image saved with image %1").arg(frame_image.source==""?"off":"on"), null )
                    AsemanApp.requestPermissions(["android.permission.WRITE_EXTERNAL_STORAGE",
                                                  "android.permission.READ_EXTERNAL_STORAGE"],
                                                 function(res) {
                        if(res["android.permission.WRITE_EXTERNAL_STORAGE"] == true &&
                           res["android.permission.READ_EXTERNAL_STORAGE"] == true) {
                            writer.save(Devices.picturesLocation + "/Meikade", Qt.size(1080, 1080/frame.ratio))
                        }
                    })
                }
            }
        }
    }

    Item {
        id: main_frame
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: footer.top
        anchors.top: header.bottom
        anchors.margins: 8*Devices.density

        Item {
            id: render_frame
            width: frame.xwidth
            height: frame.xheight
            anchors.centerIn: parent
            scale: 1/xratio

            Rectangle {
                id: frame
                anchors.centerIn: parent
                width: xwidth
                height: xheight
                color: "#ebc220"

                property real ratio: 1
                property real parentRatio: main_frame.width/main_frame.height

                property string imagePath: "stickers/images/0_1.png"
                property int imageType: StickerModel.StickerDouble

                property real xwidth: (ratio>parentRatio? main_frame.width : main_frame.height*ratio)*xratio
                property real xheight: (ratio>parentRatio? main_frame.width/ratio : main_frame.height)*xratio

                Image {
                    id: frame_image
                    anchors.fill: parent
                    sourceSize: Qt.size(width*2, height*2)
                    fillMode: Image.PreserveAspectCrop
                }

                Item {
                    id: frame_source
                    anchors.fill: parent
                    visible: false

                    Image {
                        id: top_right_sticker
                        width: frame_mask.width*0.4
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: frame_mask.width*0.1
                        fillMode: Image.PreserveAspectFit
                        source: frame.imagePath
                        visible: frame.imageType == StickerModel.StickerTopRight
                    }

                    Image {
                        id: btm_left_sticker
                        width: frame_mask.width*0.4
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.margins: frame_mask.width*0.1
                        fillMode: Image.PreserveAspectFit
                        source: frame.imagePath
                        visible: frame.imageType == StickerModel.StickerBottomLeft
                    }

                    Item {
                        id: squere_frame
                        width: frame.ratio>1? frame.xheight - frame.xheight/3 : frame.xwidth - frame.xwidth/2
                        height: width
                        anchors.centerIn: parent

                        Column {
                            id: frame_mask
                            width: parent.width
                            anchors.centerIn: parent
                            spacing: 40*Devices.density

                            Image {
                                id: top_sticker
                                width: frame_mask.width*0.8
                                anchors.horizontalCenter: parent.horizontalCenter
                                fillMode: Image.PreserveAspectFit
                                source: frame.imagePath
                                visible: frame.imageType == StickerModel.StickerDouble
                            }

                            Text {
                                id: txt
                                width: frame.xwidth
                                anchors.horizontalCenter: parent.horizontalCenter
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                font.pixelSize: fontSize*globalFontDensity*Devices.fontDensity * frame_mask.width/(320*Devices.density)
                                color: images_frame.color
                                lineHeight: 1.3

                                property int fontSize: 25
                            }

                            Image {
                                id: btm_sticker
                                width: top_sticker.width
                                anchors.horizontalCenter: parent.horizontalCenter
                                fillMode: Image.PreserveAspectFit
                                source: frame.imagePath
                                visible: frame.imageType == StickerModel.StickerDouble
                                transform: Scale { origin.x: btm_sticker.width/2; origin.y: btm_sticker.height/2; yScale: -1}
                            }
                        }
                    }

                    Column {
                        id: logos_column
                        x: frame.imageType == StickerModel.StickerBottomLeft? parent.width - width - 20*Devices.density : 20*Devices.density
                        y:frame.imageType == StickerModel.StickerBottomLeft? 20*Devices.density : parent.height - height - 20*Devices.density
                        spacing: 15*Devices.density

                        Text {
                            id: poet_txt
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: meikade_logo.height/2
                            font.family: txt.font.family
                            color: images_frame.color
                        }

                        Image {
                            id: meikade_logo
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: squere_frame.width*0.25
                            height: width/2
                            sourceSize: Qt.size(width, height)
                            source: "icons/logo.png"
                        }
                    }
                }

                Rectangle {
                    id: images_frame
                    anchors.fill: frame_source
                    visible: false
                    color: "#1b1b1b"
                }

                OpacityMask {
                    anchors.fill: images_frame
                    source: images_frame
                    maskSource: frame_source
                }
            }
        }
    }

    Rectangle {
        id: footer
        width: parent.width
        height: 80*Devices.density + View.navigationBarHeight
        anchors.bottom: parent.bottom
        color: Meikade.nightTheme? "#333333" : "#eeeeee"

        AsemanListView {
            id: listv
            anchors.fill: parent
            anchors.bottomMargin: View.navigationBarHeight
            model: smodel
            orientation: Qt.Horizontal
            layoutDirection: View.layoutDirection
            clip: true
            delegate: Rectangle {
                height: listv.height
                width: height
                color: {
                    if(Meikade.nightTheme)
                        marea.pressed? "#222222" : "#00000000"
                    else
                        marea.pressed? "#dddddd" : "#00000000"
                }

                Column {
                    anchors.centerIn: parent

                    Item {
                        id: icon_frame
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 48*Devices.density
                        height: width
                        visible: img.status == Image.Ready || model.state==StickerModel.Color || model.state==StickerModel.Font

                        Image {
                            id: img
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            source: itemImage
                            visible: false
                        }

                        LevelAdjust {
                            anchors.fill: source
                            source: img
                            minimumOutput: Meikade.nightTheme? "#00000000" : "#00ffffff"
                            maximumOutput: Meikade.nightTheme? "#ffffffff" : "#ff000000"
                        }

                        Rectangle {
                            id: color_rect
                            anchors.fill: parent
                            radius: 5*Devices.density
                            color: model.state==StickerModel.Color || model.state==StickerModel.Font? stateCommand : "#00000000"

                            Text {
                                anchors.centerIn: parent
                                text: model.state==StickerModel.Font? qsTr("Font") : "T"
                                color: model.state==StickerModel.Color? stateCommand2 : (model.state==StickerModel.Font? "#ffffff" : "#00000000")
                                font.family: model.state==StickerModel.Font? stateCommand : AsemanApp.globalFont.family
                                font.pixelSize: model.state==StickerModel.Font? stateCommand2*Devices.density*0.6 : 18*Devices.density
                            }
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: Meikade.nightTheme? "#ffffff" : "#222222"
                        text: name
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: icon_frame.visible? 10*Devices.density : 16*Devices.density
                    }
                }

                MouseArea {
                    id: marea
                    anchors.fill: parent
                    onClicked: {
                        switch(model.state)
                        {
                        case StickerModel.Category:
                            if(stateCommand == StickerModel.OpenImage)
                                file_viewer_component.createObject(sticker_dialog)
                            else
                                smodel.state = stateCommand
                            break

                        case StickerModel.Size:
                            frame.ratio = stateCommand
                            break

                        case StickerModel.Color:
                            frame.color = stateCommand
                            images_frame.color = stateCommand2
                            break

                        case StickerModel.OpenImage:
                            break

                        case StickerModel.Sticker:
                            frame_source.visible = true
                            frame.imagePath = stateCommand
                            frame.imageType = stateCommand2
                            frame_source.visible = false
                            break

                        case StickerModel.Font:
                            txt.font.family = stateCommand
                            txt.fontSize = stateCommand2
                            break

                        case StickerModel.Logo:
                            frame_source.visible = true
                            if(stateCommand == StickerModel.MeikadeLogo)
                                meikade_logo.visible = !meikade_logo.visible
                            else
                            if(stateCommand == StickerModel.PoetLogo)
                                poet_txt.visible = !poet_txt.visible
                            frame_source.visible = false
                            break
                        }
                    }
                }
            }
        }

        HScrollBar {
            scrollArea: listv; width: parent.width; anchors.top: parent.top
            color: "#888888"; orientation: Qt.Horizontal; forceVisible: true
            height: 6*Devices.density; opacity: 1;
//            visible: smodel.state != StickerModel.Category
        }
    }

    Rectangle {
        id: progress_rect
        anchors.fill: parent
        color: "#aa000000"
        visible: false

        MouseArea {
            anchors.fill: parent
            onWheel: wheel.accepted = false
        }

        BusyIndicator {
            id: indicator
            anchors.centerIn: parent
        }

        Text {
            id: tik
            anchors.centerIn: parent
            font.pixelSize: 15*globalFontDensity*Devices.fontDensity
            font.family: Awesome.family
            color: "#e6e6e6"
            text: Awesome.fa_check
            visible: !indicator.running
        }

        Timer {
            id: indicator_disabler
            interval: 2000
            onTriggered: {
                indicator.running = false
                indicator_hide_timer.restart()
                var shared = Devices.shareFile(writer.lastDest)
                if(!shared)
                    Devices.openFile("file://" + writer.lastDest)
            }
        }

        Timer {
            id: indicator_hide_timer
            interval: 1000
            onTriggered: progress_rect.visible = false
        }
    }

    Component {
        id: file_viewer_component
        Item {
            id: fv_item
            anchors.fill: sticker_dialog

            property bool visibled: false

            onVisibledChanged: {
                if(visibled)
                    BackHandler.pushHandler(fv_item, fv_item.back)
                else
                    BackHandler.removeHandler(fv_item)
            }

            Rectangle {
                id: shadow_area
                anchors.fill: parent
                color: "#000000"
                opacity: visibled? 0.5 : 0

                Behavior on opacity {
                    NumberAnimation {easing.type: Easing.OutCubic; duration: 300}
                }
            }

            Rectangle {
                id: fv_area
                width: parent.width
                height: parent.height
                x: visibled? 0 : -sticker_dialog.width

                Behavior on x {
                    NumberAnimation {easing.type: Easing.OutCubic; duration: 300}
                }

                Rectangle {
                    width: parent.width
                    height: Devices.standardTitleBarHeight

                    Header {
                        anchors.fill: parent
                        titleFont.pixelSize: 10*globalFontDensity*Devices.fontDensity
                        light: Meikade.nightTheme
                        backButton: false
                        text: qsTr("Select Image")
                        backButtonText: ""
                        statusBar: false
                        shadow: !MeikadeGlobals.iosStyle
                    }

                    Row {
                        anchors.fill: parent
                        anchors.margins: 10*Devices.density
                        layoutDirection: View.layoutDirection==Qt.LeftToRight? Qt.RightToLeft : Qt.LeftToRight

                        QtControls.Button {
                            anchors.verticalCenter: parent.verticalCenter
                            width: height*2
                            highlighted: true
                            text: qsTr("Unset")
                            onClicked: {
                                frame_image.source = ""
                                close()
                            }
                        }
                    }
                }

                FileSystemView {
                    id: fsview
                    anchors.fill: parent
                    anchors.topMargin: Devices.standardTitleBarHeight
                    clip: true
                    root: AsemanApp.startPath
                    filters: ["*.jpg", "*.png"]
                    onClickedOnFile: {
                        frame_image.source = fileUrl
                        close()
                    }
                }

                HScrollBar {
                    scrollArea: fsview; height: fsview.height
                    anchors.right: fsview.right; anchors.top: fsview.top
                    color: "#333333"
                }

                TitleBarShadow {
                    anchors.top: fsview.top
                    width: parent.width
                    visible: !MeikadeGlobals.iosStyle
                }
            }

            function back() {
                if(fsview.back())
                    return false

                close()
            }

            function close() {
                visibled = 0
                Tools.jsDelayCall(300, function(){fv_item.destroy()})
            }

            Component.onCompleted: {
                visibled = true
            }
        }
    }
}
