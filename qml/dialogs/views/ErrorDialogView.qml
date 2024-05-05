import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Layouts 1.3
import components 1.0
import globals 1.0

Item {
    id: element
    width: Constants.width
    height: columnLayout.height
    property alias bodyLabel: bodyLabel
    property alias titleLabel: titleLabel
    property alias repeater: repeater

    signal itemClicked(int index, string title)

    Rectangle {
        color: Colors.background
        anchors.fill: parent
        opacity: 0.7
    }

    ColumnLayout {
        id: columnLayout
        anchors.right: parent.right
        anchors.left: parent.left
        spacing: 0

        ColumnLayout {
            Layout.topMargin: 12 * Devices.density
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 10
            spacing: 6 * Devices.density

            MLabel {
                id: titleLabel
                Layout.fillWidth: true
                font.bold: true
                font.pixelSize: 10 * Devices.fontDensity
                horizontalAlignment: Devices.isAndroid ? Text.AlignLeft : Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "Title"
            }

            MLabel {
                id: bodyLabel
                Layout.fillWidth: true
                Layout.fillHeight: true
                font.pixelSize: 9 * Devices.fontDensity
                horizontalAlignment: Devices.isAndroid ? Text.AlignLeft : Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "Message's body"
            }
        }

        Rectangle {
            Layout.topMargin: 6 * Devices.density
            Layout.fillWidth: true
            Layout.preferredHeight: 1 * Devices.density
            color: Colors.foreground
            visible: !Devices.isAndroid
            opacity: 0.1
        }

        RowLayout {
            spacing: 0
            Layout.fillWidth: true

            Repeater {
                id: repeater
                model: ["Ok"]
                MButton {
                    id: btn
                    Layout.fillWidth: true
                    highlighted: true
                    flat: true
                    text: modelData
                    onClicked: element.itemClicked(model.index, modelData)
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:2;anchors_height:100;anchors_width:100}
}
##^##*/

