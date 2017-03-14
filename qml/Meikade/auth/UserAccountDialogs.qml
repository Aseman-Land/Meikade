import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "."
import "../globals"

Item {
    id: userAccount

    SignupDialog {
        id: signupDialog
        onClosed: loginDialog.open()
    }

    LoginDialog {
        id: loginDialog
        onSignupRequest: {
            signupDialog.open()
            signupDialog.clear()
        }
    }

    LoginPhoneDialog {
        id: login2Dialog
    }

    function open() {
        loginDialog.open()
        loginDialog.clear()
    }
}
