import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls 2.0
import globals 1.0

Page {
    id: loginPage
    width: Constants.width
    height: Constants.height

    property alias loginForm: loginForm
    property Viewport viewport: _viewport

    signal loginRequest(string number)
    signal codeRequest(string code)
    signal signupRequest(string firstName, string lastName)

    function code(timeout) {
        _viewport.append(codeComponent, {"timeout": timeout}, "page")
    }

    function signup() {
        _viewport.append(signupComponent, {}, "page")
    }

    Viewport {
        id: _viewport
        anchors.fill: parent
        mainItem: LoginForm {
            id: loginForm
            anchors.fill: parent
            sendBtn.onClicked: loginPage.loginRequest(phoneTxt.text)
            phoneTxt.onAccepted: loginPage.loginRequest(phoneTxt.text)
            cancelBtn.onClicked: viewport.closeLast()
        }
    }

    Component {
        id: codeComponent
        CodeForm {
            id: codeForm
            anchors.fill: parent
            sendCodeBtn.onClicked: loginPage.codeRequest(codeTxt.text)
            codeTxt.onAccepted: loginPage.codeRequest(codeTxt.text)
            cancelBtn.onClicked: viewport.closeLast()
            timerLabel.text: {
                var s = timeout % 60; if (s < 10) s = "0" + s
                var m = Math.floor(timeout / 60); if (m < 10) m = "0" + m
                return m + ":" + s
            }

            property int timeout

            Timer {
                running: true
                repeat: true
                interval: 1000
                onTriggered: codeForm.timeout--
            }
        }
    }
    Component {
        id: signupComponent
        SignupForm {
            anchors.fill: parent
            sendBtn.onClicked: loginPage.signupRequest(fnameTxt.text, lnameTxt.text)
            fnameTxt.onAccepted: lnameTxt.forceActiveFocus()
            lnameTxt.onAccepted: loginPage.signupRequest(fnameTxt.text, lnameTxt.text)
            cancelBtn.onClicked: viewport.closeLast()
        }
    }
}
