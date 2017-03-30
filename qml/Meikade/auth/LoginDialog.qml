import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import AsemanServer 1.0 as Server
import "."
import "../globals"

Dialog {
    id: loginDialog
    title: qsTr("Log-In")
    x: parent.width/2 - width/2
    y: parent.height/2 - height/2
    dim: true
    modal: true
    closePolicy: Popup.CloseOnPressOutside

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
            id: usernameField
            Layout.preferredWidth: {
                var res = loginDialog.parent.width - 100*Devices.density
                if(res > 350*Devices.density)
                    res = 350*Devices.density
                return res
            }
            placeholderText: qsTr("Username")
            inputMethodHints: Qt.ImhNoPredictiveText
            selectByMouse: true
            validator: RegExpValidator{regExp: /\w+/i }
        }
        TextField {
            id: passwordField
            Layout.preferredWidth: usernameField.Layout.preferredWidth
            placeholderText: qsTr("Password")
            echoMode: TextInput.Password
            passwordMaskDelay: 1000
            passwordCharacter: '*'
        }

        Button {
            text: qsTr("Log-In")
            enabled: !usernameField.errorAvailable && !passwordField.errorAvailable
            highlighted: true
            flat: true
            Layout.preferredWidth: usernameField.Layout.preferredWidth
            onClicked: {
                var dlg = showGlobalWait( qsTr("Please Wait..."), true )
                AsemanServices.auth.logIn(usernameField.text, passwordField.text, Devices.deviceName, AsemanServices.meikadeAppId, function(res, error){
                    if(!res || !error.null) {
                        dlg.destroy()
                        showTooltip(error.value)
                        return
                    }

                    loginDialog.close()
                    AsemanServices.authSettings.sessionId = res
                    AsemanServices.activeSession( function(){ dlg.destroy() } )
                })
            }
        }
    }

    function clear() {
        usernameField.clear()
        passwordField.clear()
    }
}
