import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import components 1.0
import globals 1.0
import routes 1.0
import requests 1.0
import models 1.0
import "views"

SettingsView {
    id: dis
    menuBtn.onClicked: ViewportType.open = false
    ViewportType.gestureWidth: 30 * Devices.density

    loginBtn.onClicked: Viewport.controller.trigger("float:/auth/float", {})
    logoutBtn.onClicked: {
        var properties = {
            "title": qsTr("Logout"),
            "body": qsTr("Do you realy want to logout?"),
            "buttons": [qsTr("Cancel"), qsTr("Logout")]
        };

        var obj = Viewport.controller.trigger("dialog:/general/error", properties);
        obj.itemClicked.connect(function(idx) {
            switch (idx) {
            case 0: // Cancel
                break;

            case 1: // Logout
                logoutReq.networkManager.get(logoutReq)
                break;
            }
            obj.ViewportType.open = false;
        })
    }

    TextFormater {
        id: formater
        delimiter: ","
        count: 3
        input: "" + Math.floor(dis.balance / 1000)
    }

    LogoutRequest {
        id: logoutReq
        allowGlobalBusy: true
        onSuccessfull: {
            AsemanGlobals.accessToken = "";
            AsemanGlobals.lastSync = "";

            dis.ViewportType.open = false;
            GlobalSignals.snackbarRequest(qsTr("Logout Successfully"))
        }
    }

    Timer {
        id: initTimer
        running: true
        interval: 100
        repeat: false
    }

    phraseSwitch.onCheckedChanged: if (!initTimer.running) AsemanGlobals.phrase = phraseSwitch.checked
    phraseSwitch.checked: AsemanGlobals.phrase

    mixedHeaderSwitch.onCheckedChanged: if (!initTimer.running) AsemanGlobals.mixedHeaderColor = mixedHeaderSwitch.checked? 1 : 0
    mixedHeaderSwitch.checked: AsemanGlobals.mixedHeaderColor == 1? 1 : 0

    phraseNumberSwitch.onCheckedChanged: if (!initTimer.running) AsemanGlobals.phraseNumber = phraseNumberSwitch.checked
    phraseNumberSwitch.checked: AsemanGlobals.phraseNumber

    languageCombo.onActivated: {
        if (initTimer.running)
            return;

        var currentTheme = themeCombo.currentIndex;
        AsemanGlobals.language = languageCombo.model.get(languageCombo.currentIndex).key;
        Tools.jsDelayCall(10, function(){ themeCombo.currentIndex = currentTheme });
    }
    themeCombo.onActivated: {
        if (initTimer.running)
            return;

        AsemanGlobals.iosTheme = themeCombo.currentIndex;
        AsemanGlobals.androidTheme = themeCombo.currentIndex;
    }

    fontSizeSlider.onValueChanged: if (!initTimer.running) AsemanGlobals.fontSize = fontSizeSlider.value
    fontSizeSlider.value: AsemanGlobals.fontSize

    Component.onCompleted: {
        for (var i=0; i<languageCombo.model.count; i++) {
            if (languageCombo.model.get(i).key == AsemanGlobals.language) {
                languageCombo.currentIndex = i;
                break;
            }
        }

        themeCombo.currentIndex = AsemanGlobals.iosTheme;
    }
}


