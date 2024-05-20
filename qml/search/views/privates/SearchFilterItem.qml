import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0

ItemDelegate {
    width: Constants.width
    height: 50 * Devices.density

    property bool addMode: true
    property string poetName: "Poet Name"
    property alias frame: frame

    Rectangle {
        id: frame
        anchors.fill: parent
        anchors.leftMargin: 8 * Devices.density
        anchors.rightMargin: 8 * Devices.density
        anchors.margins: 4 * Devices.density
        radius: 10 * Devices.density
        color: "transparent"
        border.color: "#888"
        border.width: 1 * Devices.density
        opacity: 0.6
    }

    RowLayout {
        anchors.fill: frame
        anchors.leftMargin: 20 * Devices.density
        anchors.rightMargin: 20 * Devices.density

        Label {
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            font.pixelSize: 9 * Devices.fontDensity
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 1
            elide: Text.ElideRight
            text: poetName
        }

        Label {
            Layout.alignment: Qt.AlignCenter
            font.family: MaterialIcons.family
            font.pixelSize: 16 * Devices.fontDensity
            text: addMode? MaterialIcons.mdi_plus : MaterialIcons.mdi_close
            color: addMode? "#0a0" : "#c00"
        }
    }
}
