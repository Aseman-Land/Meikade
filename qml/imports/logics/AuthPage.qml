import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0
import requests 1.0

AuthView {
    id: auth

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

    LoginRequest {
        id: loginReq
        allowGlobalBusy: true
        onSuccessfull: {
            auth.ViewportType.open = false;
            AsemanGlobals.accessToken = response.result.token;
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
}
