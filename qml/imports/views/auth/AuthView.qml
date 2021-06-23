import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls 2.0
import requests 1.0
import globals 1.0

Page {
    id: loginPage
    width: Constants.width
    height: Constants.height

    property alias introMode: loginForm.introMode
    property alias loginForm: loginForm
    property Viewport viewport: _viewport
    property alias localViewport: _viewport

    signal loginRequest(string username, string password)
    signal signupRequest(string username, string password, string fullname, string email)
    signal forgetRequest(string username)

    function signup() {
        _viewport.append(signupComponent, {}, "page")
    }

    Viewport {
        id: _viewport
        anchors.fill: parent
        mainItem: LoginForm {
            id: loginForm
            anchors.fill: parent
            backgroudMouseArea.onClicked: Devices.hideKeyboard()
            sendBtn.onClicked: loginPage.loginRequest(userTxt.text, passTxt.text)
            passTxt.onAccepted: loginPage.loginRequest(userTxt.text, passTxt.text)
            signupBtn.onClicked: _viewport.append(signupComponent, {}, "page")
            forgetBtn.onClicked: _viewport.append(forgetComponent, {}, "page")
            cancelBtn.onClicked: viewport.closeLast()
        }
    }

    HeaderMenuButton {
        ratio: 1
        visible: _viewport.count
        buttonColor: Colors.headerTextColor
        onClicked: _viewport.closeLast()
    }

    Component {
        id: signupComponent
        SignupForm {
            id: signupForm
            anchors.fill: parent
            usernameError.visible: Math.floor(userCheckReq.status / 100) != 2 && userCheckReq.status > 0
            userCheckIndicator.running: userTxt.isValid && userCheckTimer.running || userCheckReq.refreshing
            userTxt.onTextChanged: userCheckTimer.restart()
            backgroudMouseArea.onClicked: Devices.hideKeyboard()
            sendBtn.onClicked: loginPage.signupRequest(userTxt.text, passTxt.text, fullnameTxt.text, emailTxt.text)
            emailTxt.onAccepted: loginPage.signupRequest(userTxt.text, passTxt.text, fullnameTxt.text, emailTxt.text)
            cancelBtn.onClicked: viewport.closeLast()
            cancelBtn.visible: !introMode

            Timer {
                id: userCheckTimer
                interval: 1000
                repeat: false
                onTriggered: if (signupForm.userTxt.isValid) userCheckReq.networkManager.get(userCheckReq)
            }

            UserCheckRequest {
                id: userCheckReq
                _username: signupForm.userTxt.text
            }
        }
    }

    Component {
        id: forgetComponent
        ForgetPasswordForm {
            id: forgetForm
            anchors.fill: parent
            backgroudMouseArea.onClicked: Devices.hideKeyboard()
            cancelBtn.onClicked: viewport.closeLast()
            cancelBtn.visible: !introMode
            sendBtn.onClicked: loginPage.forgetRequest(userTxt.text)
        }
    }
}
