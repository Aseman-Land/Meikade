import QtQuick 2.0
import AsemanTools 1.0

Column {
    id: column
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.right: parent.right

    Item {
        width: main.width - 40*Devices.density
        height: 200*Devices.density

        Flickable {
            id: flick
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            contentWidth: txt.width
            contentHeight: txt.height
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            rebound: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 0
                }
            }

            Text {
                id: txt
                width: flick.width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 10*Devices.density
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                color: "#333333"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("We change some poets on meikade.")
            }
        }

        ScrollBar {
            scrollArea: flick; height: flick.height
            anchors.left: parent.right; anchors.top: flick.top; color: "#333333"
            anchors.leftMargin: 2*Devices.density
        }
    }

    Button {
        width: parent.width
        textFont.family: AsemanApp.globalFont.family
        textFont.pixelSize: 10*globalFontDensity*Devices.fontDensity
        textColor: "#0d80ec"
        normalColor: "#00000000"
        highlightColor: "#660d80ec"
        text: qsTr("OK")
        onClicked: {
            AsemanApp.back()
        }
    }
}
