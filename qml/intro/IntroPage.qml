import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import requests 1.0
import globals 1.0
import models 1.0
import "views"
import "../auth"

IntroView {
    id: home

    Component.onCompleted: {
        Tools.jsDelayCall(1000, function(){ home.list.currentIndex = 0 });
        Tools.jsDelayCall(1000, function(){ setupThemeForm.listView.currentIndex = 0 });
    }

    Timer {
        id: stopTimer
        interval: 800
        repeat: false
        running: true
    }

    AuthPage {
        parent: home.loginForm
        anchors.fill: parent
        introMode: true
        loginForm.skipLoginBtn.onClicked: list.currentIndex++
        onLoggedInSuccessfully: {
            if (signUpLogin)
                list.currentIndex++
            else
                AsemanGlobals.introDone = true
        }
    }

    welcomForm {
        nextBtn.onClicked: list.currentIndex++
    }

    setupThemeForm {
        nextBtn.onClicked: list.currentIndex++
        listView.onCurrentIndexChanged: {
            if (stopTimer.running)
                return;

            var listView = setupThemeForm.listView;
            var item = listView.model.get(listView.currentIndex);

            AsemanGlobals.mixedHeaderColor = !item.configColorToolbar;
            if (isAndroidStyle) {
                switch (item.configTheme) {
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
                switch (item.configTheme) {
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

            AsemanGlobals.themeDone = true;
        }
    }
}


