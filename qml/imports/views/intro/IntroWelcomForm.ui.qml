import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import micros 1.0

Page {
    id: homeForm
    width: Constants.width
    height: Constants.height
    property alias languageCombo: languageCombo

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20 * Devices.density
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -20 * Devices.density
        spacing: 6 * Devices.density

        Image {
            source: AsemanGlobals.testLogoDisable? "" : "icons/meikade.png"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: 192 * Devices.density
            Layout.preferredHeight: 192 * Devices.density
            sourceSize.width: 256 * Devices.density
            sourceSize.height: 256 * Devices.density
        }

        Label {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: 16 * Devices.fontDensity
            text: qsTr("Welcome to Meikade 4") + Translations.refresher
        }

        Label {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Meikade 4 is designed to increase your poetry reading experiance and increase your sense quality.") + Translations.refresher
        }

        Label {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("So It's neccessary to take some times and do next steps to personalize your Meikade. Choose language and press \"Next\" if you ready.") + Translations.refresher
        }

        ComboBox {
            id: languageCombo
            Layout.topMargin: 20 * Devices.density
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: 200 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            model: ["English", "فارسی"]
        }
    }
}
