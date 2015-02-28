import QtQuick 2.0
import AsemanTools 1.0

Rectangle {
    width: 100
    height: 62
    color: "#dddddd"

    Rectangle {
        id: header
        width: parent.width
        height: View.statusBarHeight + Devices.standardTitleBarHeight
        color: "#705AFF"

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
            fontSize: 11*Devices.fontDensity
            textFont.bold: false
            visible: backButton
            onClicked: {
                AsemanApp.back()
                Devices.hideKeyboard()
            }
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: header.height
        contentWidth: column.width
        contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick
        clip: true

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

                Image {
                    width: 192
                    height: width
                    sourceSize: Qt.size(width,height)
                }

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 10*Devices.fontDensity
                    font.bold: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#333333"
                    text: qsTr("About Nile:")
                }

                Text {
                    width: parent.width
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 10*Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#333333"
                    text: qsTr("Nile is an Iranian software corporation that makes software for Desktop computers, Android, iOS, Mac, Windows Phone, Ubuntu Phone and ...\n"+
                               "Nile create Free and OpenSource projects.")
                }
            }
        }
    }
}
