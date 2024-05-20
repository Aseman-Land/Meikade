import QtQuick 2.12
import QtQuick.Controls 2.3
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Base 2.0
import QtQuick.Layouts 1.3
import globals 1.0

ItemDelegate {
    id: element
    width: 100
    height: 100

    property alias iconText: iconText
    property alias title: title

    GridLayout {
        id: column
        columnSpacing: 8 * Devices.density
        rowSpacing: 1 * Devices.density
        x: AsemanGlobals.viewMode == 2? parent.width/2 - width/2 : (LayoutMirroring.enabled? parent.width - width - 20 * Devices.density : 20 * Devices.density)
        anchors.verticalCenter: parent.verticalCenter
        columns: AsemanGlobals.viewMode == 2? 1 : 2

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
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: qsTr("Label") + Translations.refresher
            font.capitalization: Font.AllUppercase
            font.pixelSize: (AsemanGlobals.viewMode == 2? 7 : 9) * Devices.fontDensity
        }
    }
}
