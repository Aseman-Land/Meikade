import QtQuick 2.0
import "../design/auth"
import "../globals"

AuthPage {

    onLoginRequest: code(90)
    onCodeRequest: signup()
    onSignupRequest: ViewController.viewport.closeLast()
}
