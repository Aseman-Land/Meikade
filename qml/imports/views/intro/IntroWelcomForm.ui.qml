import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import requests 1.0
import micros 1.0

Page {
    id: homeForm
    width: Constants.width
    height: Constants.height
    property alias languageCombo: languageCombo
    property alias nextBtn: nextBtn

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20 * Devices.density
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -20 * Devices.density
        spacing: 0

        Item {
            Layout.preferredWidth: 128 * Devices.density
            Layout.preferredHeight: 128 * Devices.density
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Image {
                source: AsemanGlobals.testLogoDisable? "" : "icons/meikade.png"
                width: parent.width * 2
                height: parent.height * 2
                anchors.centerIn: parent
                scale: 0.5
                sourceSize.width: width
                sourceSize.height: height
            }
        }

        Label {
            Layout.topMargin: 6 * Devices.density
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: 16 * Devices.fontDensity
            text: qsTr("Welcome to Meikade 4") + Translations.refresher
        }

        Label {
            Layout.topMargin: 6 * Devices.density
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Please choose your language") + Translations.refresher
        }

        ComboBox {
            id: languageCombo
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: 300 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            model: ["English", "فارسی"]
        }

        Button {
            id: nextBtn
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.preferredWidth: 300 * Devices.density
            text: qsTr("Next") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
            highlighted: true
        }
    }
}
