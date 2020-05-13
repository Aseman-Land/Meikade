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
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.left: parent.left
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
                font.pixelSize: 8 * Devices.fontDensity
                text: "Short Description"
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                Material.foreground: Material.background
                IOSStyle.foreground: IOSStyle.background
            }

            RoundedImage {
                id: image
                Layout.preferredWidth: 32 * Devices.density
                Layout.preferredHeight: 32 * Devices.density
                sourceSize.width: 50 * Devices.density
                sourceSize.height: 50 * Devices.density
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                radius: delItem.radius
            }
        }
    }
}
