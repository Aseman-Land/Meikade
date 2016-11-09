import QtQuick 2.0
import AsemanTools 1.0

Rectangle {
    anchors.fill: parent
    color: "#dddddd"
    clip: true

    readonly property string title: qsTr("About Nile Group")

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: "#00A0E3"

        TitleBarShadow {
            width: header.width
            anchors.top: header.bottom
        }
    }

    Flickable {
        id: flickable
        anchors.top: header.bottom
        anchors.bottom: home_btn.top
        width: parent.width
        contentWidth: column.width
        contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        rebound: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 0
            }
        }

        Item {
            id: main_item
            width: flickable.width
            height: column.height>flickable.height? column.height : flickable.height

            Column {
                id: column
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20*Devices.density
                anchors.verticalCenter: parent.verticalCenter

                Item {width: 20; height: 20*Devices.density}

                Image {
                    width: 150*Devices.density
                    height: width
                    sourceSize: Qt.size(width,height)
                    source: "icons/nilegroup.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item {width: 2; height: 20*Devices.density}

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: -20*Devices.density
                    height: 50*Devices.density
                    color: "#cccccc"

                    Text {
                        anchors.centerIn: parent
                        font.family: AsemanApp.globalFont.family
                        font.pixelSize: 12*globalFontDensity*Devices.fontDensity
                        font.bold: true
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        color: "#333333"
                        text: qsTr("About Nile Group")
                    }
                }

                Item {width: 2; height: 20*Devices.density}

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#333333"
                    text: qsTr("Nile is an Iranian software corporation that makes software for Desktop computers, Android, iOS, Mac, Windows Phone, Ubuntu Phone and ...\n"+
                               "Nile create Free and OpenSource projects.")

                    Component.onCompleted: {
                        width = flickable.width - 40*Devices.density
                    }
                }
            }
        }
    }

    Button {
        id: home_btn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: View.navigationBarHeight + 10*Devices.density
        anchors.horizontalCenter: parent.horizontalCenter
        height: 40*Devices.density
        width: 120*Devices.density
        normalColor: "#00A0E3"
        highlightColor: Qt.darker(normalColor)
        textColor: "#ffffff"
        radius: 4*Devices.density
        text: qsTr("Home Page")
        onClicked: Qt.openUrlExternally("http://nilegroup.org")
    }
}
