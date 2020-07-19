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
    property alias forgetBtn: forgetBtn
    property alias signupBtn: signupBtn
    property alias passTxt: passTxt
    property alias cancelBtn: cancelBtn
    property alias headerItem: headerItem
    property alias sendBtn: sendBtn
    property alias userTxt: userTxt
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
                    text: qsTr("If you created account before, Just enter your username below. Otherwise click on \"Create new account\" button.") + Translations.refresher
                    Layout.fillWidth: true
                    Layout.bottomMargin: 20 * Devices.density
                    wrapMode: Text.WordWrap
                }

                TextField {
                    id: userTxt
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    placeholderText: qsTr("Username") + Translations.refresher
                    font.pixelSize: 10 * Devices.fontDensity
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                    validator: RegExpValidator { regExp: /[a-z][a-z0-9_]+/ }
                    onAccepted: passTxt.focus = true

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

                TextField {
                    id: passTxt
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    placeholderText: qsTr("Password") + Translations.refresher
                    font.pixelSize: 10 * Devices.fontDensity
                    horizontalAlignment: Text.AlignHCenter
                    echoMode: TextInput.Password
                    visible: userTxt.length > 5
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
                        text: MaterialIcons.mdi_lock
                        color: Colors.primary
                    }
                }

                Button {
                    id: sendBtn
                    text: qsTr("Login") + Translations.refresher
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    highlighted: true
//                    enabled: userTxt.length > 5 && passTxt.length > 5
                }

                Button {
                    id: signupBtn
                    text: qsTr("Create new account") + Translations.refresher
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40 * Devices.density
                    Layout.bottomMargin: -10 * Devices.density
                    font.pixelSize: 9 * Devices.fontDensity
                    font.underline: true
                    flat: true
                    highlighted: true
                    IOSStyle.accent: Colors.accent
                }

                Button {
                    id: forgetBtn
                    text: qsTr("Forget your password") + Translations.refresher
                    Layout.bottomMargin: 40 * Devices.density
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40 * Devices.density
                    font.pixelSize: 9 * Devices.fontDensity
                    font.underline: true
                    flat: true
                    highlighted: true
                    IOSStyle.accent: Colors.accent
                }
            }
        }
    }

    Header {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Authenticating") + Translations.refresher
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
