import QtQuick 2.12
import globals 1.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0

Item {
    id: myMeikade
    width: 100
    height: column.height + 20 * Devices.density

    property alias numberLabel: numberLabel
    property alias unitLabel: unitLabel

    ColumnLayout {
        id: column
        y: 10 * Devices.density
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10 * Devices.density
        spacing: 4 * Devices.density

        Label {
            id: numberLabel
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 13 * Devices.fontDensity
            font.bold: true
            text: "11"
            color: "#fff"
        }

        Label {
            id: unitLabel
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 9 * Devices.fontDensity
            text: "Per Week"
            color: "#fff"
        }
    }
}
