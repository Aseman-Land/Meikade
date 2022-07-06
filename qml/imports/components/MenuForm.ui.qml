import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import globals 1.0

Rectangle {
    id: menuRoot
    width: 200 * Devices.density
    height: column.height + menuRoot.radius * 2
    color: Colors.background
    radius: Constants.radius

    property alias model: menuRepeater.model

    signal itemClicked(int index)

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: menuRoot.radius
        spacing: 0

        Repeater {
            id: menuRepeater
            model: 4

            ItemDelegate {
                Layout.preferredHeight: 50 * Devices.density
                Layout.fillWidth: true
                enabled: model.enabled
                opacity: enabled? 1 : 0.5
                onClicked: menuRoot.itemClicked(model.index)

                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 14 * Devices.density
                    spacing: 14 * Devices.density

                    Label {
                        font.family: MaterialIcons.family
                        font.pixelSize: 12 * Devices.fontDensity
                        text: MaterialIcons[model.icon]
                    }

                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 9 * Devices.fontDensity
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        text: model.title
                    }
                }

                Separator {
                    visible: menuRepeater.count != model.index + 1
                }
            }
        }
    }
}
