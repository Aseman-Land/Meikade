import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
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

    languageCombo.onCurrentIndexChanged: if (!initTimer.running) AsemanGlobals.language = languageCombo.model.get(languageCombo.currentIndex).key
    themeCombo.onCurrentIndexChanged: {
        if (initTimer.running)
            return;

        if (isAndroidStyle) {
            switch (themeCombo.currentIndex) {
            case 0:
                AsemanGlobals.androidTheme = Material.System;
                break;
            case 1:
                AsemanGlobals.androidTheme = Material.Light;
                break;
            case 2:
                AsemanGlobals.androidTheme = Material.Dark;
                break;
            }
        } else {
            switch (themeCombo.currentIndex) {
            case 0:
                AsemanGlobals.iosTheme = IOSStyle.System;
                break;
            case 1:
                AsemanGlobals.iosTheme = IOSStyle.Light;
                break;
            case 2:
                AsemanGlobals.iosTheme = IOSStyle.Dark;
                break;
            }
        }
    }

    fontSizeSlider.onValueChanged: if (!initTimer.running) AsemanGlobals.fontSize = fontSizeSlider.value
    fontSizeSlider.value: AsemanGlobals.fontSize

    accountStateLabel.text: Subscription.title + Translations.refresher
    accountDaysLabel.text: GTranslations.translate( qsTr("%1 days").arg(Subscription.premiumDays) ) + Translations.refresher
    accountPremiumBuy.onClicked: Viewport.controller.trigger("bottomdrawer:/account/premium/buy", {"forceDark": true})

    Component.onCompleted: {
        for (var i=0; i<languageCombo.model.count; i++) {
            if (languageCombo.model.get(i).key == AsemanGlobals.language) {
                languageCombo.currentIndex = i;
                break;
            }
        }

        if (isAndroidStyle) {
            switch (AsemanGlobals.androidTheme) {
            case Material.System:
                themeCombo.currentIndex = 0;
                break;
            case Material.Light:
                themeCombo.currentIndex = 1;
                break;
            case Material.Dark:
                themeCombo.currentIndex = 2;
                break;
            }
        } else {
            switch (AsemanGlobals.iosTheme) {
            case IOSStyle.System:
                themeCombo.currentIndex = 0;
                break;
            case IOSStyle.Light:
                themeCombo.currentIndex = 1;
                break;
            case IOSStyle.Dark:
                themeCombo.currentIndex = 2;
                break;
            }
        }
    }
}


