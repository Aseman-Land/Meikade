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

            ColumnLayout {
                id: columnLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20 * Devices.density
                spacing: 0

                Label {
                    id: loginLabel
                    font.pixelSize: 9 * Devices.fontDensity
                    text: qsTr("Enter your current password and tap on the Submit button.") + Translations.refresher
                    Layout.fillWidth: true
                    Layout.bottomMargin: 20 * Devices.density
                    wrapMode: Text.WordWrap
                }

                TextField {
                    id: passTxt
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    placeholderText: qsTr("Password") + Translations.refresher
                    font.pixelSize: 10 * Devices.fontDensity
                    horizontalAlignment: Text.AlignHCenter
                    echoMode: TextInput.Password
                    passwordCharacter: '*'
                    passwordMaskDelay: 500
                    selectByMouse: true
                    onAccepted: sendBtn.focus = true

                    Label {
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

                Button {
                    id: sendBtn
                    text: qsTr("Submit") + Translations.refresher
                    Layout.fillWidth: true
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
        shadow: isAndroidStyle

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
