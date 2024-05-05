import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import globals 1.0
import requests 1.0
import components 1.0

MPage {
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

        MLabel {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: 16 * Devices.fontDensity
            text: qsTr("Setup Completed") + Translations.refresher
        }

        MLabel {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 9 * Devices.fontDensity
//            visible: Bootstrap.initialized
            text: qsTr("You can also do below optional steps:") + Translations.refresher
        }

        MLabel {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.topMargin: 20 * Devices.density
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 9 * Devices.fontDensity
            visible: AsemanGlobals.accessToken.length == 0 /*&& Bootstrap.initialized*/
            text: qsTr("To keep your data like favorites safe, You can create Meikade Cloud Account and login to sync your data. To do that click below button:") + Translations.refresher
        }

        MButton {
            id: signInBtn
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            highlighted: true
            flat: true
            visible: AsemanGlobals.accessToken.length == 0 && Bootstrap.initialized
            text: qsTr("SignIn / SignUp") + Translations.refresher
        }

        MLabel {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.topMargin: 20 * Devices.density
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 9 * Devices.fontDensity
            visible: false
            text: qsTr("To help Meikade better, you can check/uncheck below switch to send anaymous data for us.") + Translations.refresher
        }

        MSwitch {
            id: helpBtn
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible: false
            text: qsTr("Help Meikade") + Translations.refresher
        }
    }

    MButton {
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
