import QtQuick 2.12
import components 1.0
import globals 1.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.Controls 2.0

MPage {
    id: page
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias cancelBtn: cancelBtn
    property alias headerItem: headerItem
    property alias sendBtn: sendBtn
    property alias passTxt: passTxt
    property alias loginLabel: loginLabel
    property alias backgroudMouseArea: backgroudMouseArea

    AsemanFlickable {
        id: flickable
        anchors.fill: parent
        contentWidth: scene.width
        contentHeight: scene.height

        Item {
            id: scene
            width: flickable.width
            height: flickable.height

            MouseArea {
                id: backgroudMouseArea
                anchors.fill: parent
            }

            Column {
                id: columnLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20 * Devices.density
                spacing: 8 * Devices.density

                MLabel {
                    id: loginLabel
                    font.pixelSize: 9 * Devices.fontDensity
                    text: qsTr("Enter your new password and tap on the Change button.") + Translations.refresher
                    width: parent.width
                    wrapMode: Text.WordWrap
                }

                MTextField {
                    id: passTxt
                    width: parent.width
                    placeholderText: qsTr("Password") + Translations.refresher
                    font.pixelSize: 10 * Devices.fontDensity
                    horizontalAlignment: Text.AlignHCenter
                    echoMode: TextInput.Password
                    passwordCharacter: '*'
                    passwordMaskDelay: 500
                    selectByMouse: true
                    onAccepted: sendBtn.focus = true

                    MLabel {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        anchors.margins: 8 * Devices.density
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_account
                        color: Colors.primary
                    }
                }

                MButton {
                    id: sendBtn
                    text: qsTr("Change") + Translations.refresher
                    width: parent.width
                    font.pixelSize: 9 * Devices.fontDensity
                    highlighted: true
                    enabled: passTxt.length > 5
                }
            }
        }
    }

    Header {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Change Password") + Translations.refresher
        color: Colors.headerColor
        light: !Colors.lightHeader
        shadow: Devices.isAndroid

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            Button {
                id: cancelBtn
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 8 * Devices.density
                text: qsTr("Cancel") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
            }
        }
    }
}
