import AsemanQml.Base 2.0
import AsemanQml.Awesome 2.0
import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "."
import "../globals"

Dialog {
    id: signupDialog
    title: qsTr("Sign-Up")
    x: parent.width/2 - width/2
    y: parent.height/2 - height/2
    dim: true
    modal: true
    closePolicy: Popup.CloseOnPressOutside

    onVisibleChanged: {
        if(visible)
            BackHandler.pushHandler(this, function(){visible = false})
        else
            BackHandler.removeHandler(this)
    }

    ColumnLayout {

        TextField {
            id: usernameField
            Layout.preferredWidth: emailField.Layout.preferredWidth
            placeholderText: qsTr("Username")
            selectByMouse: true
            inputMethodHints: Qt.ImhNoPredictiveText
            color: {
                if(focus || errorAvailable == -1)
                    return MeikadeGlobals.foregroundColor
                if(errorAvailable)
                    return "#ff0000"
                else
                    return Material.color(Material.Teal)
            }
            validator: RegExpValidator{regExp: /\w+/i }
            onTextChanged: errorAvailable = -1
            onFocusChanged: {
                if(focus || text.length < 4)
                {
                    errorAvailable = (text.length < 4? 1 : 0)
                    return
                }
                if(errorAvailable != -1)
                    return

                unameBusyIndicator.running = true
                AsemanServices.auth.checkUsername(text, function(result, error){
                    errorAvailable = (result? 1 : 0)
                    unameBusyIndicator.running = false
                })
            }

            BusyIndicator {
                id: unameBusyIndicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: -12*Devices.density
                height: 46*Devices.density
                width: height
                running: false
                transformOrigin: Item.Center
                scale: 0.5
            }

            property int errorAvailable: -1
        }

        TextField {
            id: emailField
            Layout.preferredWidth: {
                var res = signupDialog.parent.width - 100*Devices.density
                if(res > 350*Devices.density)
                    res = 350*Devices.density
                return res
            }
            placeholderText: qsTr("Email")
            selectByMouse: true
            inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhEmailCharactersOnly
            color: {
                if(focus || errorAvailable == -1)
                    return MeikadeGlobals.foregroundColor
                if(errorAvailable)
                    return "#ff0000"
                else
                    return Material.color(Material.Teal)
            }
            validator: RegExpValidator{regExp: /(\w|\.)+@\w+\.\w+/i }
            onTextChanged: errorAvailable = -1
            onFocusChanged: {
                if(focus || text.length < 5)
                {
                    errorAvailable = (text.length < 5? 1 : 0)
                    return
                }
                if(errorAvailable != -1)
                    return

                busyIndicator.running = true
                AsemanServices.auth.checkEmail(text, function(result, error){
                    errorAvailable = (result? 1 : 0)
                    busyIndicator.running = false
                })
            }

            BusyIndicator {
                id: busyIndicator
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: -12*Devices.density
                height: 46*Devices.density
                width: height
                running: false
                transformOrigin: Item.Center
                scale: 0.5
            }

            property int errorAvailable: -1
        }
        TextField {
            id: passwordField
            Layout.preferredWidth: emailField.Layout.preferredWidth
            placeholderText: qsTr("Password")
            echoMode: TextInput.Password
            passwordMaskDelay: 1000
            passwordCharacter: '*'
            color: {
                if(focus || errorAvailable == -1)
                    return MeikadeGlobals.foregroundColor
                if(errorAvailable)
                    return "#ff0000"
                else
                    return Material.color(Material.Teal)
            }
            onTextChanged: errorAvailable = (text.length < 8? 1 : 0)

            property int errorAvailable: -1
        }
        TextField {
            id: fullNameField
            Layout.preferredWidth: emailField.Layout.preferredWidth - 50*Devices.density
            placeholderText: qsTr("Full name")
            selectByMouse: true
            color: {
                if(focus || errorAvailable == -1)
                    return MeikadeGlobals.foregroundColor
                if(errorAvailable)
                    return "#ff0000"
                else
                    return Material.color(Material.Teal)
            }
            onTextChanged: errorAvailable = (text.length < 3? 1 : 0)

            property int errorAvailable: -1
        }

        Button {
            text: qsTr("Sign-Up")
            highlighted: true
            flat: true
            enabled: !emailField.errorAvailable && !usernameField.errorAvailable && !passwordField.errorAvailable && !fullNameField.errorAvailable
            Layout.preferredWidth: emailField.Layout.preferredWidth
            onClicked: {
                var dlg = showGlobalWait( qsTr("Please Wait..."), true )
                AsemanServices.auth.signUp(usernameField.text, passwordField.text, emailField.text, fullNameField.text, function(res, error){
                    if(!res || !error.null) {
                        dlg.destroy()
                        showTooltip(error.value)
                        return
                    }

                    signupDialog.close()
                    AsemanServices.auth.logIn(usernameField.text, passwordField.text, Devices.deviceName, AsemanServices.meikadeAppId, function(res, error){
                        if(!res || !error.null) {
                            dlg.destroy()
                            showTooltip(error.value)
                            return
                        }

                        AsemanServices.authSettings.sessionId = res
                        AsemanServices.activeSession( function(){ dlg.destroy() } )
                    })
                })
            }
        }
    }

    function clear() {
        emailField.clear()
        passwordField.clear()
        fullNameField.clear()
    }
}
