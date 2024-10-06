import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.Viewport 2.0
import requests 1.0
import globals 1.0
import "privates"

Page {
    id: changePage
    width: Constants.width
    height: Constants.height

    property Viewport viewport: _viewport

    property bool forgetMode: false

    signal checkCodeRequest(string code)
    signal checkPasswordRequest(string password)
    signal changePasswordRequest(string password)

    function changePassword() {
        _viewport.append(changePasswordComponent, {}, "page")
    }

    Viewport {
        id: _viewport
        anchors.fill: parent
        mainItem: Item {
            id: loginForm
            anchors.fill: parent

            Loader {
                anchors.fill: parent
                active: forgetMode
                sourceComponent: ChangePasswordUsingCodeForm {
                    anchors.fill: parent
                    backgroudMouseArea.onClicked: Devices.hideKeyboard()
                    sendBtn.onClicked: changePage.checkCodeRequest(passTxt.text)
                    cancelBtn.onClicked: viewport.closeLast()
                }
            }

            Loader {
                anchors.fill: parent
                active: !forgetMode
                sourceComponent: ChangePasswordUsingPasswordForm {
                    anchors.fill: parent
                    backgroudMouseArea.onClicked: Devices.hideKeyboard()
                    sendBtn.onClicked: changePage.checkPasswordRequest(passTxt.text)
                    cancelBtn.onClicked: viewport.closeLast()
                }
            }
        }
    }

    HeaderMenuButton {
        ratio: 1
        visible: _viewport.count
        buttonColor: Colors.headerTextColor
        onClicked: _viewport.closeLast()
    }

    Component {
        id: changePasswordComponent
        ChangePasswordForm {
            id: changePasswordForm
            anchors.fill: parent
            backgroudMouseArea.onClicked: Devices.hideKeyboard()
            cancelBtn.onClicked: viewport.closeLast()
            sendBtn.onClicked: changePage.changePasswordRequest(passTxt.text)
        }
    }
}

