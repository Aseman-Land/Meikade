import AsemanTools 1.1
import AsemanTools.Awesome 1.0
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

    onVisibleChanged: {
        if(visible)
            BackHandler.pushHandler(this, function(){visible = false})
        else
            BackHandler.removeHandler(this)
    }

    ColumnLayout {

        TextField {
            id: emailField
            Layout.preferredWidth: signupDialog.parent.width - 100*Devices.density
            placeholderText: qsTr("Email")
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
            validator: RegExpValidator{regExp: /\w+@\w+\.\w+/i }
            onTextChanged: errorAvailable = -1
            onFocusChanged: {
                if(focus || text.length < 5)
                    return
                if(errorAvailable != -1)
                    return

                busyIndicator.running = true
                AsemanServices.auth.checkUsername(text, function(result, error){
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
        }
        TextField {
            id: fullNameField
            Layout.preferredWidth: emailField.Layout.preferredWidth - 50*Devices.density
            placeholderText: qsTr("Full name")
            selectByMouse: true
        }

        Button {
            text: qsTr("Sign-Up")
            highlighted: true
            flat: true
            Layout.preferredWidth: emailField.Layout.preferredWidth
        }
    }

    function clear() {
        emailField.clear()
        passwordField.clear()
        fullNameField.clear()
    }
}
