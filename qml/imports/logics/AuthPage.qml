import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0

AuthView {

    onLoginRequest: code(90)
    onCodeRequest: signup()
    onSignupRequest: Viewport.viewport.closeLast()
}
