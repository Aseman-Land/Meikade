import QtQuick 2.0
import "../design/auth"

AuthPage {

    onLoginRequest: code(90)
    onCodeRequest: signup()
}
