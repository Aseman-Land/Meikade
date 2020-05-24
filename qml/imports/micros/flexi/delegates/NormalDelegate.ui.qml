import QtQuick 2.12
import globals 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Base 2.0

AbstractDelegate {
    id: delItem
    width: 400
    height: 100 * Devices.density
    property alias subtitle: subtitle
    property alias image: image
    property alias title: title
    property alias background: background

    Rectangle {
        anchors.fill: parent
        color: Colors.primary
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#18f"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10 * Devices.density
        spacing: 10 * Devices.density

        Label {
            id: title
            Layout.fillWidth: true
            font.pixelSize: 9 * Devices.fontDensity
            text: "Title Poet"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 1
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            Material.foreground: Material.background
            IOSStyle.foreground: IOSStyle.background
        }

        RowLayout {
            Layout.fillWidth: true

            Label {
                id: subtitle
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                font.pixelSize: 8 * Devices.fontDensity
                text: "Short Description"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                Material.foreground: Material.background
                IOSStyle.foreground: IOSStyle.background
            }

            Item {
                Layout.alignment: Qt.AlignBottom | Qt.AlignRight
                height: 42 * Devices.density
                width: 42 * Devices.density

                CachedImage {
                    id: image
                    width: parent.width * 2
                    height: parent.height * 2
                    anchors.centerIn: parent
                    scale: 0.5
                    sourceSize.width: 100 * Devices.density
                    sourceSize.height: 100 * Devices.density
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    radius: delItem.radius
                }
            }
        }
    }
}
