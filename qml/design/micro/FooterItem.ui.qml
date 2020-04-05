import QtQuick 2.12
import MeikadeDesign 1.0
import QtQuick.Controls 2.3
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Base 2.0
import QtQuick.Layouts 1.3

ItemDelegate {
    id: element
    width: 100
    height: 100

    property alias iconText: iconText
    property alias title: title

    ColumnLayout {
        id: column
        spacing: 1 * Devices.density
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Label {
            id: iconText
            Layout.preferredHeight: 30 * Devices.density
            text: MaterialIcons.mdi_bell
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: MaterialIcons.family
            font.pixelSize: 18 * Devices.fontDensity
        }
        Label {
            id: title
            text: qsTr("Label") + Translations.refresher
            font.capitalization: Font.AllUppercase
            font.pixelSize: 7 * Devices.fontDensity
        }
    }
}
