import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import globals 1.0
import components 1.0
import "../../../general/views/privates"

MPage {
    id: dis
    width: Constants.width
    height: Constants.height

    property alias listView: frame.listView
    property alias nextBtn: nextBtn

    MLabel {
        anchors.top: parent.top
        anchors.topMargin: 4 * Devices.density + Devices.statusBarHeight
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 16 * Devices.fontDensity
        text: qsTr("Theme") + Translations.refresher
    }

    ThemeWizardFrame {
        id: frame
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 500 * Devices.density
    }


    MButton {
        id: nextBtn
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: Devices.navigationBarHeight + Devices.standardTitleBarHeight
        width: 300 * Devices.density
        text: qsTr("Next") + Translations.refresher
        font.pixelSize: 9 * Devices.fontDensity
        highlighted: true
    }
}
