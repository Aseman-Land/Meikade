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
    property alias headerItem: headerItem
    property alias scene: scene

    property alias cancelBtn: cancelBtn
    property alias loginLabel: loginLabel
    property alias userTxt: userTxt
    property alias passTxt: passTxt
    property alias fullnameTxt: fullnameTxt
    property alias emailTxt: emailTxt
    property alias sendBtn: sendBtn
    property alias backgroudMouseArea: backgroudMouseArea

    AsemanFlickable {
        id: flickable
        anchors.fill: parent
        contentWidth: scene.width
        contentHeight: scene.height + Devices.keyboardHeight

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
                    text: qsTr("Type your phone number for us. We will send you a code for logging into the Meikade.") + Translations.refresher
                    Layout.fillWidth: true
                    Layout.bottomMargin: 20 * Devices.density
                    wrapMode: Text.WordWrap
                }

                TextField {
                    id: userTxt
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    placeholderText: qsTr("Username") + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    inputMethodHints: Qt.ImhDigitsOnly
                    horizontalAlignment: Text.AlignLeft
                    leftPadding: 34 * Devices.density
                    onAccepted: passTxt.focus = true

                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        anchors.margins: 8 * Devices.density
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_account
                        color: Colors.accent
                    }
                }

                TextField {
                    id: passTxt
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    placeholderText: qsTr("Password") + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    inputMethodHints: Qt.ImhDigitsOnly
                    horizontalAlignment: Text.AlignLeft
                    leftPadding: 34 * Devices.density
                    echoMode: TextInput.Password
                    passwordCharacter: '*'
                    passwordMaskDelay: 500
                    onAccepted: fullnameTxt.focus = true

                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        anchors.margins: 8 * Devices.density
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_lock
                        color: Colors.accent
                    }
                }

                TextField {
                    id: fullnameTxt
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    placeholderText: qsTr("Full Name") + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignLeft
                    leftPadding: 34 * Devices.density
                    onAccepted: emailTxt.focus = true

                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        anchors.margins: 8 * Devices.density
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_pencil
                        color: Colors.accent
                    }
                }

                TextField {
                    id: emailTxt
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    placeholderText: qsTr("Email") + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignLeft
                    leftPadding: 34 * Devices.density
                    onAccepted: sendBtn.focus = true

                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        anchors.margins: 8 * Devices.density
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_email
                        color: Colors.accent
                    }
                }

                Button {
                    id: sendBtn
                    text: qsTr("Sign Up") + Translations.refresher
                    Layout.bottomMargin: 20 * Devices.density
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    highlighted: true
                    enabled: userTxt.length > 5 && passTxt.length > 5 && fullnameTxt.length > 2 && emailTxt.length > 5
                }
            }
        }
    }

    Header {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Signup") + Translations.refresher
        color: Colors.header
        shadow: Devices.isAndroid

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
                IOSStyle.accent: Qt.darker(Colors.header, 1.3)
                Material.accent: Qt.darker(Colors.header, 1.3)
                Material.theme: Material.Dark
                Material.elevation: 0
            }
        }
    }
}



