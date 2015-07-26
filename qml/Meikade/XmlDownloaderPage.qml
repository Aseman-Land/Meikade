import QtQuick 2.0
import AsemanTools 1.0

Rectangle {
    width: 100
    height: 62

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: "#60DB4A"
        z: 2

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
        anchors.centerIn: list_indicator
        font.pixelSize: 11*globalFontDensity*Devices.fontDensity
        font.family: AsemanApp.globalFont.family
        text: "Can't connect to the server!"
        color: "#333333"
        visible: xml_model.errors.length != 0 || (listv.count == 0 && !list_indicator.active)
    }

    ListView {
        id: listv
        width: parent.width
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

        delegate: Rectangle {
            width: listv.width
            height: 50*Devices.density
            color: marea.pressed? "#440d80ec" : "#00000000"

            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20*Devices.density
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
                height: model.installed? 26*Devices.density : 22*Devices.density
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
                        return qsTr("Ready to download")
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

