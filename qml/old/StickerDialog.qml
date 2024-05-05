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
import AsemanQml.GraphicalEffects 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import Meikade 1.0
import components 1.0
import globals 1.0

Rectangle {
    id: sticker_dialog
    color: "#111111"

    readonly property bool lightToolbar: true

    property alias text: txt.text
    property alias poet: poet_txt.text

    property real xratio: 2

    FontLoader{
        source: Fonts.resourcePath + "/BYekan.ttf"
        onStatusChanged: if(status == FontLoader.Ready) txt.font.family = name
    }
    Connections {
        target: Devices
        onSelectImageResult: {
            frame_image.source = Devices.localFilesPrePath + path
        }
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
            console.debug(dest)
            if (Devices.isIOS)
                Devices.saveToGallery(dest)
            else
                lastDest = dest
            indicator_disabler.restart()
        }

        property string lastDest
    }

    Header {
        id: header
        width: parent.width
        color: "#fff"
        light: false
        text: qsTr("Share")

        HeaderMenuButton {
            ratio: 1
            buttonColor: "#333"
            onClicked: BackHandler.back()
        }

        MButton {
            anchors.right: parent.right
            anchors.rightMargin: 10 * Devices.density
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: Devices.statusBarHeight/2
            width: height*2
            text: qsTr("Save")
            highlighted: true
            onClicked: {
                indicator.running = true
                progress_rect.visible = true
                AsemanApp.requestPermissions(["android.permission.WRITE_EXTERNAL_STORAGE",
                                              "android.permission.READ_EXTERNAL_STORAGE"],
                                             function(res) {
                    if(res["android.permission.WRITE_EXTERNAL_STORAGE"] == true &&
                       res["android.permission.READ_EXTERNAL_STORAGE"] == true) {
                        let path = Devices.isIOS? AsemanApp.homePath : Devices.picturesLocation
                        writer.save(path + "/Meikade", Qt.size(1080, 1080/frame.ratio))
                    }
                });
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
                                font.pixelSize: fontSize*Devices.fontDensity * frame_mask.width/(320*Devices.density)
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
                            source: "stickers/general/logo.png"
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
        color: Colors.background

        AsemanListView {
            id: listv
            anchors.fill: parent
            anchors.bottomMargin: View.navigationBarHeight
            model: smodel
            orientation: Qt.Horizontal
            clip: true
            delegate: Rectangle {
                height: listv.height
                width: height
                color: marea.pressed? Colors.deepBackground : "#00000000"

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

                        MLabel {
                            id: deleteIcon
                            anchors.centerIn: parent
                            font.family: MaterialIcons.family
                            font.pixelSize: 18 * Devices.fontDensity
                            text: MaterialIcons.mdi_close
                            visible: model.state == StickerModel.Category && stateCommand == StickerModel.OpenImage && (frame_image.source + "").length
                            color: "#a00"
                        }

                        LevelAdjust {
                            anchors.fill: source
                            source: img
                            visible: !deleteIcon.visible
                            minimumOutput: Colors.darkMode? "#00000000" : "#00ffffff"
                            maximumOutput: Colors.darkMode? "#ffffffff" : "#ff000000"
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
                        color: Colors.foreground
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
                            if(stateCommand == StickerModel.OpenImage) {
                                if ((frame_image.source + "").length)
                                    frame_image.source = ""
                                else {
                                    AsemanApp.requestPermissions(["android.permission.WRITE_EXTERNAL_STORAGE",
                                                                  "android.permission.READ_EXTERNAL_STORAGE"],
                                                                 function(res) {
                                        if(res["android.permission.WRITE_EXTERNAL_STORAGE"] == true &&
                                           res["android.permission.READ_EXTERNAL_STORAGE"] == true) {
                                            Devices.getOpenPictures();
                                        }
                                    });
                                }
                            } else {
                                smodel.state = stateCommand
                            }
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

        MBusyIndicator {
            id: indicator
            anchors.centerIn: parent
        }

        Text {
            id: tik
            anchors.centerIn: parent
            font.pixelSize: 15*Devices.fontDensity
            font.family: MaterialIcons.family
            color: "#e6e6e6"
            text: MaterialIcons.mdi_check
            visible: !indicator.running
        }

        Timer {
            id: indicator_disabler
            interval: 2000
            onTriggered: {
                indicator.running = false
                indicator_hide_timer.restart()

                if (Devices.isIOS) {
                    GlobalSignals.snackbarRequest( qsTr("Sticker saved to Gallery") )
                } else {
                    GlobalSignals.snackbarRequest( qsTr("Sticker saved on %1").arg(writer.lastDest) )
                    var shared = Devices.shareFile(writer.lastDest)
                    if(!shared)
                        Devices.openFile(writer.lastDest)
                }
            }
        }

        Timer {
            id: indicator_hide_timer
            interval: 1000
            onTriggered: progress_rect.visible = false
        }
    }
}
