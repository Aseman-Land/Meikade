import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import views 1.0
import globals 1.0
import requests 1.0

AuthView {
    id: auth
    Material.accent: Colors.primary
    IOSStyle.accent: Colors.primary

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
        forgetReq.username = username;
        forgetReq.networkManager.post(forgetReq);
    }

    LoginRequest {
        id: loginReq
        allowGlobalBusy: true
        onSuccessfull: {
            auth.ViewportType.open = false;
            AsemanGlobals.accessToken = response.result.token;
            GlobalSignals.snackbarRequest(qsTr("Logged in Successfully"));
            GlobalSignals.reinitSync(Viewport.controller);
        }
    }

    RegisterRequest {
        id: registerReq
        allowGlobalBusy: true
        onSuccessfull: {
            loginReq.username = username;
            loginReq.password = password;
            loginReq.networkManager.post(loginReq);
        }
    }

    ForgetPasswordRequest {
        id: forgetReq
        allowGlobalBusy: true
        onSuccessfull: {
            localViewport.closeLast()
            GlobalSignals.snackbarRequest( qsTr("Check your email, assigned to your account.") )
        }
    }
}
