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
    property alias finishBtn: finishBtn
    property alias helpBtn: helpBtn
    property alias signInBtn: signInBtn

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20 * Devices.density
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -20 * Devices.density
        spacing: 6 * Devices.density

        Label {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: 16 * Devices.fontDensity
            text: qsTr("Setup Completed") + Translations.refresher
        }

        Label {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("You can also do below optional steps:") + Translations.refresher
        }

        Label {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.topMargin: 20 * Devices.density
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("To keep your data like favorites safe, You can create Meikade Cloud Account and login to sync your data. To do that click below button:") + Translations.refresher
        }

        Button {
            id: signInBtn
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            highlighted: true
            flat: true
            text: qsTr("SignIn / SignUp") + Translations.refresher
        }

        Label {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.topMargin: 20 * Devices.density
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("To help Meikade better, you can check/uncheck below switch to send anaymous data for us.") + Translations.refresher
        }

        Switch {
            id: helpBtn
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Help Meikade") + Translations.refresher
        }
    }

    Button {
        id: finishBtn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 40 * Devices.density
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Devices.standardTitleBarHeight
        highlighted: true
        text: qsTr("Finish") + Translations.refresher
    }
}
