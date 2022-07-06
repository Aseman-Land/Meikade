import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import requests 1.0
import "views"

AuthView {
    id: auth

    property bool signUpLogin: false

    signal loggedInSuccessfully()

    onLoginRequest: {
        loginReq.username = username;
        loginReq.password = Constants.hashPassword(password);
        loginReq.networkManager.post(loginReq);
    }

    onSignupRequest: {
        registerReq.username = username;
        registerReq.password = Constants.hashPassword(password);
        registerReq.name = fullname;
        registerReq.email = email;
        registerReq.networkManager.post(registerReq);
    }

    onForgetRequest: {
        forgetReq._username = username;
        forgetReq.networkManager.get(forgetReq);
    }

    LoginRequest {
        id: loginReq
        allowGlobalBusy: true
        onSuccessfull: {
            auth.ViewportType.open = false;
            AsemanGlobals.accessToken = response.result.token;
            AsemanGlobals.username = loginReq.username;
            GlobalSignals.snackbarRequest(qsTr("Logged in Successfully"));
            GlobalSignals.reinitSync(Viewport.controller);
            auth.loggedInSuccessfully()
        }
    }

    RegisterRequest {
        id: registerReq
        allowGlobalBusy: true
        onSuccessfull: {
            signUpLogin = true
            loginReq.username = username;
            loginReq.password = password;
            loginReq.networkManager.post(loginReq);
        }
    }

    ForgetPasswordRequest {
        id: forgetReq
        allowGlobalBusy: true
        onSuccessfull: {
            auth.ViewportType.open = false;
            Viewport.controller.trigger("float:/auth/changePassword", {"forgetMode": true, "accessToken": response.result.token})
            GlobalSignals.snackbarRequest( qsTr("Check your email, assigned to your account.") )
        }
    }
}


