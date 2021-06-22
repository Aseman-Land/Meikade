import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import views 1.0
import globals 1.0
import requests 1.0

ChangePasswordView {
    id: auth

    property string accessToken

    onChangePasswordRequest: {
        changePassReq.password = Constants.hashPassword(password);
        changePassReq.networkManager.patch(changePassReq)
    }

    onCheckPasswordRequest: {
        loginReq.username = AsemanGlobals.username;
        loginReq.password = Constants.hashPassword(password);
        loginReq.networkManager.post(loginReq);
    }

    onCheckCodeRequest: {
        loginForgetReq._code = code;
        loginForgetReq.networkManager.post(loginForgetReq);
    }

    LoginToForgetPasswordRequest {
        id: loginForgetReq
        allowGlobalBusy: true
        accessToken: auth.accessToken
        onSuccessfull: {
            changePassReq.accessToken = response.result.token;
            auth.changePassword();
        }
    }

    LoginRequest {
        id: loginReq
        allowGlobalBusy: true
        accessToken: ""
        onSuccessfull: {
            changePassReq.accessToken = response.result.token;
            auth.changePassword();
        }
    }

    UserChangePasswordRequest {
        id: changePassReq
        allowGlobalBusy: true
        accessToken: ""
        onSuccessfull: {
            GlobalSignals.snackbarRequest( qsTr("Password changed successfully") );
            auth.ViewportType.open = false;
        }
    }
}
