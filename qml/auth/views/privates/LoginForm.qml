import QtQuick 2.12
import globals 1.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import AsemanQml.Controls 2.0

Page {
    id: page
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias forgetBtn: columnLayout.forgetBtn
    property alias signupBtn: columnLayout.signupBtn
    property alias passTxt: columnLayout.passTxt
    property alias cancelBtn: cancelBtn
    property alias headerItem: headerItem
    property alias sendBtn: columnLayout.sendBtn
    property alias userTxt: columnLayout.userTxt
    property alias introMode: columnLayout.introMode
    property alias loginLabel: columnLayout.loginLabel
    property alias skipLoginBtn: columnLayout.skipLoginBtn
    property alias backgroudMouseArea: backgroudMouseArea

    AsemanFlickable {
        id: flickable
        anchors.fill: parent
        contentWidth: scene.width
        contentHeight: scene.height
        flickDeceleration: Flickable.VerticalFlick

        Item {
            id: scene
            width: flickable.width
            height: Math.max(flickable.height, columnLayout.height)

            MouseArea {
                id: backgroudMouseArea
                anchors.fill: parent
            }

            LoginColumnForm {
                id: columnLayout
                width: Math.min(parent.width - 40 * Devices.density, 350*Devices.density)
                anchors.centerIn: parent
                anchors.verticalCenterOffset: headerItem.height
            }
        }
    }

    Header {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Authenticating") + Translations.refresher
        color: Colors.headerColor
        light: !Colors.lightHeader
        shadow: Devices.isAndroid
        visible: !introMode

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: cancelBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Cancel") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.accent: Qt.darker(Colors.primary, 1.3)
                Material.accent: Qt.darker(Colors.primary, 1.3)
                Material.theme: Material.Dark
                Material.elevation: 0
            }
        }
    }
}
