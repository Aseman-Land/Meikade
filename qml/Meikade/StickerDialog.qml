import QtQuick 2.0
import QtGraphicalEffects 1.0
import AsemanTools 1.0
import Meikade 1.0

Rectangle {
    width: 100
    height: 62
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
        color: "#333333"

        Header {
            anchors.fill: parent
            titleFont.pixelSize: 12*Devices.fontDensity
            light: true
            backButton: false
            text: qsTr("Share")
        }

        Row {
            anchors.fill: parent
            anchors.margins: 4*Devices.density
            layoutDirection: Meikade.languageDirection==Qt.LeftToRight? Qt.RightToLeft : Qt.LeftToRight

            Button {
                anchors.verticalCenter: parent.verticalCenter
                height: 32*Devices.density
                width: height*2
                radius: 5*Devices.density
                normalColor: "#2A7B8F"
                highlightColor: Qt.darker(normalColor, 1.1)
                fontSize: 9*Devices.fontDensity
                text: qsTr("Save")
                onClicked: {
                    indicator.active = true
                    progress_rect.visible = true
                    writer.save(Devices.picturesLocation + "/Meikade", Qt.size(1280, 1280/frame.ratio))
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
                color: "#1b1b1b"

                property real ratio: 1
                property real parentRatio: main_frame.width/main_frame.height
                property string imagePath: "stickers/images/s0.png"

                property real xwidth: (ratio>parentRatio? main_frame.width : main_frame.height*ratio)*xratio
                property real xheight: (ratio>parentRatio? main_frame.width/ratio : main_frame.height)*xratio

                Behavior on width {
                    NumberAnimation{easing.type: Easing.OutCubic; duration: 400}
                }
                Behavior on height {
                    NumberAnimation{easing.type: Easing.OutCubic; duration: 400}
                }

                Item {
                    id: frame_source
                    anchors.fill: parent
                    visible: false

                    Item {
                        id: squere_frame
                        width: frame.ratio>1? frame.xheight - frame.xheight/3 : frame.xwidth - frame.xwidth/2
                        height: width
                        anchors.centerIn: parent

                        Behavior on width {
                            NumberAnimation{easing.type: Easing.OutCubic; duration: 400}
                        }
                        Behavior on height {
                            NumberAnimation{easing.type: Easing.OutCubic; duration: 400}
                        }

                        Column {
                            id: frame_mask
                            width: parent.width
                            anchors.centerIn: parent
                            spacing: 10*Devices.density

                            Image {
                                id: top_sticker
                                width: frame_mask.width*0.8
                                anchors.horizontalCenter: parent.horizontalCenter
                                fillMode: Image.PreserveAspectFit
                                source: frame.imagePath
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
                                transform: Scale { origin.x: btm_sticker.width/2; origin.y: btm_sticker.height/2; yScale: -1}
                            }
                        }
                    }

                    Column {
                        id: logos_column
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: 20*Devices.density
                        spacing: 15*Devices.density

                        Text {
                            id: poet_txt
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: (txt.fontSize*Devices.fontDensity)*0.7
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
                    color: "#ebc220"
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
        color: "#333333"

        ListView {
            id: listv
            anchors.fill: parent
            anchors.bottomMargin: View.navigationBarHeight
            model: smodel
            orientation: Qt.Horizontal
            layoutDirection: Meikade.languageDirection
            delegate: Rectangle {
                height: listv.height
                width: height
                color: marea.pressed? "#222222" : "#00000000"

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
                        color: "#ffffff"
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
                            smodel.state = stateCommand
                            break

                        case StickerModel.Size:
                            frame.ratio = stateCommand
                            break

                        case StickerModel.Color:
                            frame.color = stateCommand
                            images_frame.color = stateCommand2
                            break

                        case StickerModel.Sticker:
                            frame.imagePath = stateCommand
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

        Indicator {
            id: indicator
            anchors.centerIn: parent
            light: true
            modern: true
            indicatorSize: 22*Devices.density

            property bool active: false
            onActiveChanged: {
                if(active)
                    start()
                else
                    stop()
            }
        }

        Image {
            id: tik
            anchors.centerIn: parent
            width: 22*Devices.density
            height: width
            source: "icons/tik.png"
            visible: !indicator.active
        }

        Timer {
            id: indicator_disabler
            interval: 2000
            onTriggered: {
                indicator.active = false
                indicator_hide_timer.restart()
                Devices.openFile("file://"+writer.lastDest)
            }
        }

        Timer {
            id: indicator_hide_timer
            interval: 1000
            onTriggered: progress_rect.visible = false
        }
    }
}

