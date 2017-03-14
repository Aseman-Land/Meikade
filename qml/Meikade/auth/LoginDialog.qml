import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "."
import "../globals"

Dialog {
    id: loginDialog
    title: qsTr("Log-In")
    x: parent.width/2 - width/2
    y: parent.height/2 - height/2
    dim: true
    modal: true

    signal signupRequest()

    onVisibleChanged: {
        if(visible)
            BackHandler.pushHandler(this, function(){visible = false})
        else
            BackHandler.removeHandler(this)
    }

    ColumnLayout {

        RowLayout {
            Button {
                text: qsTr("Google Account")
                highlighted: true
            }

            Button {
                text: qsTr("Signup")
                highlighted: true
                Material.accent: MeikadeGlobals.masterColor
                onClicked: {
                    signupRequest()
                    loginDialog.close()
                }
            }
        }

        TextField {
            id: emailField
            Layout.preferredWidth: loginDialog.parent.width - 100*Devices.density
            placeholderText: qsTr("Email")
            inputMethodHints: Qt.ImhNoPredictiveText
            selectByMouse: true
            validator: RegExpValidator{regExp: /\w+@\w+\.\w+/i }
        }
        TextField {
            id: passwordField
            Layout.preferredWidth: emailField.Layout.preferredWidth
            placeholderText: qsTr("Password")
            echoMode: TextInput.Password
            passwordMaskDelay: 1000
            passwordCharacter: '*'
        }

        Button {
            text: qsTr("Log-In")
            highlighted: true
            flat: true
            Layout.preferredWidth: emailField.Layout.preferredWidth
        }
    }

    function clear() {
        emailField.clear()
        passwordField.clear()
    }
}
