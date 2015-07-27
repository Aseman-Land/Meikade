import QtQuick 2.0
import AsemanTools 1.0
import Meikade 1.0

Rectangle {
    width: 100
    height: 62

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: "#3c994b"
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
                icon: "icons/back_light_64.png"
                iconHeight: 16*Devices.density
                fontSize: 11*globalFontDensity*Devices.fontDensity
                textFont.bold: false
                visible: backButton
                onClicked: {
                    AsemanApp.back()
                    Devices.hideKeyboard()
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
                text: qsTr("Store")
            }
        }

        TitleBarShadow {
            width: parent.width
            anchors.top: parent.bottom
        }
    }

    Indicator {
        id: list_indicator
        width: parent.width
        anchors.top: header.bottom
        height: 100*Devices.density
        light: false
        modern: true
        indicatorSize: 20*Devices.density

        property bool active: xml_model.refreshing
        onActiveChanged: {
            if(active)
                start()
            else
                stop()
        }
    }

    Text {
        anchors.horizontalCenter: list_indicator.horizontalCenter
        anchors.top: list_indicator.verticalCenter
        anchors.topMargin: 30*Devices.density
        font.pixelSize: 11*globalFontDensity*Devices.fontDensity
        font.family: AsemanApp.globalFont.family
        text: qsTr("Fetching poet lists...")
        color: "#333333"
        visible: list_indicator.active
    }

    Text {
        anchors.centerIn: list_indicator
        font.pixelSize: 11*globalFontDensity*Devices.fontDensity
        font.family: AsemanApp.globalFont.family
        text: qsTr("Can't connect to the server")
        color: "#333333"
        visible: xml_model.errors.length != 0 || (listv.count == 0 && !list_indicator.active)
    }

    ListView {
        id: listv
        width: parent.width
        anchors.topMargin: 2*Devices.density
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        model: xml_model
        boundsBehavior: Flickable.StopAtBounds
        rebound: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 0
            }
        }

        header: Item {
            width: listv.width
            height: title_txt.height + 4*Devices.density

            Text {
                id: title_txt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 8*Devices.density
                anchors.rightMargin: 8*Devices.density
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#888888"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("Poets list, you can download from NileGroup servers...")
                visible: listv.count != 0
            }
        }

        delegate: Rectangle {
            width: listv.width
            height: 54*Devices.density
            color: marea.pressed? "#440d80ec" : "#00000000"

            PoetImageProvider {
                id: image_provider
                poet: model.poetId
            }

            Image {
                id: poet_img
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 16*Devices.density
                anchors.right: parent.right
                height: 38*Devices.density
                width: height
                sourceSize: Qt.size(width,height)
                fillMode: Image.PreserveAspectFit
                source: image_provider.path
            }

            Text {
                id: poet_name
                anchors.right: poet_img.left
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20*Devices.density
                anchors.rightMargin: 4*Devices.density
                text: model.poetName
                horizontalAlignment: Text.AlignRight
                font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
            }

            Image {
                id: img
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20*Devices.density
                height: 26*Devices.density
                width: height
                sourceSize: Qt.size(width, height)
                source: model.installed? "icons/installed.png" : "icons/download.png"
                visible: !indicator.active
            }

            Indicator {
                id: indicator
                anchors.fill: img
                light: false
                modern: true
                indicatorSize: 18*Devices.density

                property bool active: model.installing || model.downloadingState || model.downloadedStatus
                onActiveChanged: {
                    if(active)
                        start()
                    else
                        stop()
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: img.right
                anchors.leftMargin: 10*Devices.density
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#888888"
                text: {
                    if(model.installing)
                        return qsTr("Installing")
                    else
                    if(model.downloadingState)
                        return qsTr("Downloading")
                    else
                    if(model.installed)
                        return qsTr("Installed")
                    else
                    if(model.downloadError)
                        return qsTr("Error")
                    else
                        return qsTr("Free")
                }
            }

            ProgressBar {
                width: parent.width
                height: 3*Devices.density
                anchors.bottom: parent.bottom
                visible: indicator.active
                percent: 100*model.downloadedBytes/model.fileSize
                transform: Scale { origin.x: width/2; origin.y: height/2; xScale: -1}
                color: "#00000000"
            }

            Rectangle {
                width: parent.width
                height: 1*Devices.density
                color: "#e5e5e5"
                anchors.bottom: parent.bottom
            }

            MouseArea {
                id: marea
                anchors.fill: parent
                onClicked: {
                    if(model.installed || indicator.active)
                        return

                    model.downloadingState = true
                }
            }
        }
    }

    ScrollBar {
        scrollArea: listv; height: listv.height; anchors.left: listv.left;
        anchors.top: listv.top; color: "#111111"
    }

    Component.onCompleted: xml_model.refresh()
}

