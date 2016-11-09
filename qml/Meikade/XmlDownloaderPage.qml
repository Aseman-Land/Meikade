import QtQuick 2.0
import QtQuick.Controls 2.0
import AsemanTools 1.0
import Meikade 1.0
import AsemanTools.Awesome 1.0
import QtQuick.Layouts 1.3

Rectangle {
    id: xml_page
    anchors.fill: parent
    clip: true

    readonly property string title: qsTr("Store")

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: "#3c994b"
        z: 2

        Item {
            anchors.fill: parent
            anchors.topMargin: View.statusBarHeight

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
        visible: list_indicator.running
    }

    Text {
        anchors.centerIn: list_indicator
        font.pixelSize: 11*globalFontDensity*Devices.fontDensity
        font.family: AsemanApp.globalFont.family
        text: qsTr("Can't connect to the server")
        color: "#333333"
        visible: xml_model.errors.length != 0 || (listv.count == 0 && !list_indicator.running)
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

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 16*Devices.density
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10*Devices.density
                layoutDirection: View.layoutDirection

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.preferredHeight: 38*Devices.density
                    Layout.preferredWidth: Layout.preferredHeight

                    sourceSize: Qt.size(width,height)
                    fillMode: Image.PreserveAspectFit
                    source: image_provider.path
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.fillWidth: true

                    text: model.poetName
                    horizontalAlignment: View.layoutDirection==Qt.LeftToRight? Text.AlignLeft : Text.AlignRight
                    font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
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

                Item {
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: Layout.preferredHeight

                    Text {
                        id: img
                        anchors.centerIn: parent
                        font.pixelSize: 15*globalFontDensity*Devices.fontDensity
                        font.family: Awesome.family
                        color: model.installed? "#3c994b" : "#3d3d3d"
                        text: model.installed? Awesome.fa_check_square_o : Awesome.fa_plus
                        visible: !indicator.running
                    }

                    Indicator {
                        id: indicator
                        anchors.centerIn: parent
                        width: 18*Devices.density
                        height: width
                        light: false
                        modern: true
                        running: model.installing || model.downloadingState || model.downloadedStatus
                    }
                }
            }

            ProgressBar {
                width: parent.width
                height: 3*Devices.density
                anchors.bottom: parent.bottom
                visible: indicator.running
                percent: 100*model.downloadedBytes/model.fileSize
                transform: Scale { origin.x: width/2; origin.y: height/2; xScale: View.layoutDirection==Qt.LeftToRight?1:-1}
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
                    if(model.installed || indicator.running)
                        return

                    model.downloadingState = true
                    networkFeatures.pushAction( ("Poet Download: %1").arg(model.poetId) )
                }
            }
        }
    }

    ScrollBar {
        scrollArea: listv; height: listv.height; anchors.left: listv.left;
        anchors.top: listv.top; color: "#111111"
    }

    Component.onCompleted: xml_model.refresh()
    ActivityAnalizer { object: xml_page }
}

