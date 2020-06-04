import QtQuick 2.0
import QtQuick.Controls 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import globals 1.0

MyMeikadeView {

    signedIn: AsemanGlobals.accessToken.length

    gridView.model: MyMeikadeModel {}

    settingsBtn.onClicked: Viewport.controller.trigger("page:/settings")
    onClicked: Viewport.controller.trigger(link, {})

    profileLabel.text: MyUserRequest._fullname
    authBtn.onClicked: Viewport.controller.trigger("float:/auth/float", {})
}
