import QtQuick 2.0
import AsemanTools 1.0

Rectangle {
    width: 100
    height: 62
    color: "#f0f0f0"

    AsemanFlickable {
        id: flick
        anchors.fill: parent
        anchors.leftMargin: 20*Devices.density
        anchors.rightMargin: 20*Devices.density
        anchors.bottomMargin: View.navigationBarHeight
        flickableDirection: Flickable.VerticalFlick
        contentWidth: column.width
        contentHeight: column.height
        clip: true

        Column {
            id: column
            width: flick.width

            Item {width: 20; height: 20*Devices.density}

            Image {
                width: height*3/4
                height: parent.width*0.6
                sourceSize: Qt.size(width,height)
                source: "icons/hafez_omen.jpg"
                anchors.horizontalCenter: parent.horizontalCenter
                rotation: 90
                transformOrigin: Item.Center
            }

            Item {width: 2; height: 10*Devices.density}

            TextEdit {
                width: parent.width
                wrapMode: TextEdit.Wrap
                readOnly: true
                selectByMouse: false
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 13*Devices.density
                color: "#333333"
                text: Meikade.aboutHafezOmen()
            }
        }
    }

    ScrollBar {
        scrollArea: flick; height: flick.height
        anchors.right: parent.right; anchors.top: flick.top; color: "#333333"
        anchors.rightMargin: 2*Devices.density
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }
}

