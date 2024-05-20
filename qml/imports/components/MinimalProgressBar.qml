import QtQuick 2.0
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0

Rectangle {
    Layout.preferredWidth: downloadingProgressRow.width + 20 * Devices.density
    Layout.preferredHeight: 24 * Devices.density
    width: downloadingProgressRow.width + 20 * Devices.density
    height: 24 * Devices.density
    radius: downloadProgressBar.radius
    color: "#88ffffff"
    visible: running

    IOSStyle.theme: IOSStyle.Light
    Material.theme: Material.Light

    property alias frontColor: downloadProgressBar.color
    property alias textColor: downloadProgressLabel.color

    property alias nonProgress: downloadProgressBar.visible
    property alias running: downloadingProgressIndicator.running
    property real progress
    property alias label: downloadProgressLabel.text

    Behavior on progress {
        NumberAnimation { duration: 300 }
    }

    Rectangle {
        id: downloadProgressBar
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: parent.width * progress
        color: "#88ffffff"
        radius: 7 * Devices.density
    }

    RowLayout {
        id: downloadingProgressRow
        anchors.centerIn: parent
        spacing: 2 * Devices.density

        BusyIndicator {
            id: downloadingProgressIndicator
            scale: 0.6
            Layout.preferredHeight: 28 * Devices.density
            Layout.preferredWidth: 28 * Devices.density
            Material.accent: downloadProgressLabel.color
        }

        Label {
            id: downloadProgressLabel
            font.pixelSize: 8 * Devices.fontDensity
            text: "Downloading"
            color: "#000"
        }
    }
}
