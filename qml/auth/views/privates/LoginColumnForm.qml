import QtQuick 2.14
import globals 1.0
import components 1.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.Controls 2.0

Column {
    id: columnLayout
    spacing: 8 * Devices.density

    property alias forgetBtn: forgetBtn
    property alias signupBtn: signupBtn
    property alias passTxt: passTxt
    property alias sendBtn: sendBtn
    property alias userTxt: userTxt
    property alias loginLabel: loginLabel
    property alias skipLoginBtn: skipLoginBtn
    property bool introMode: false

    MLabel {
        id: loginLabel
        font.pixelSize: 9 * Devices.fontDensity
        text: qsTr("If you created account before, Just enter your username below. Otherwise click on \"Create new account\" button.") + Translations.refresher
        width: parent.width
        wrapMode: Text.WordWrap
    }

    MTextField {
        id: userTxt
        width: parent.width
        placeholderText: qsTr("Username") + Translations.refresher
        font.pixelSize: 10 * Devices.fontDensity
        horizontalAlignment: Text.AlignHCenter
        selectByMouse: true
        inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
        validator: RegularExpressionValidator { regularExpression: /[a-z][a-z0-9_]+/ }
        onAccepted: passTxt.focus = true

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

    MTextField {
        id: passTxt
        width: parent.width
        placeholderText: qsTr("Password") + Translations.refresher
        font.pixelSize: 10 * Devices.fontDensity
        horizontalAlignment: Text.AlignHCenter
        echoMode: TextInput.Password
        visible: userTxt.length > 5
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
            text: MaterialIcons.mdi_lock
            color: Colors.primary
        }

        MButton {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 4 * Devices.density
            font.pixelSize: 12 * Devices.fontDensity
            font.family: MaterialIcons.family
            text: passTxt.echoMode == TextInput.Password? MaterialIcons.mdi_eye : MaterialIcons.mdi_eye_off
            flat: true
            highlighted: true
            width: 32 * Devices.density
            height: 32 * Devices.density
            onClicked: {
                if (passTxt.echoMode == TextInput.Password)
                    passTxt.echoMode = TextInput.Normal
                else
                    passTxt.echoMode = TextInput.Password
            }
        }
    }

    MButton {
        id: sendBtn
        text: qsTr("Login") + Translations.refresher
        width: parent.width
        font.pixelSize: 9 * Devices.fontDensity
        highlighted: true
//        enabled: userTxt.length > 5 && passTxt.length > 5
    }

    Column {
        width: parent.width

        MButton {
            id: signupBtn
            text: qsTr("Create new account") + Translations.refresher
            width: parent.width
            height: 30 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            font.underline: true
            flat: true
            highlighted: true
        }

        MButton {
            id: forgetBtn
            text: qsTr("Forget your password") + Translations.refresher
            width: parent.width
            height: 30 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            font.underline: true
            flat: true
            highlighted: true
        }

        MButton {
            id: skipLoginBtn
            text: qsTr("Skip authenticating") + Translations.refresher
            width: parent.width
            height: 30 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            font.underline: true
            flat: true
            visible: introMode
            highlighted: true
        }

        Item {
            width: 1
            height: 40 * Devices.density
        }
    }
}
