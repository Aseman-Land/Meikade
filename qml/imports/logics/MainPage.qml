import QtQuick 2.0
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0
import micros 1.0
import routes 1.0
import requests 1.0
import models 1.0

MainView {
    id: form

    readonly property bool firstPage: currentIndex == 0
    readonly property bool lightToolbar: Colors.lightHeader && currentIndex != 3

    onFirstPageChanged: {
        if (firstPage)
            BackHandler.removeHandler(form)
        else
            BackHandler.pushHandler(form, function(){ currentIndex = 0 })
    }

    Component.onCompleted: {
        if (AsemanGlobals.username.length == 0 && AsemanGlobals.accessToken.length != 0) {
            AsemanGlobals.accessToken = "";
            ViewController.trigger("float:/auth/float");
        }

        loadChangelogs();
        MessagesModel.init();
    }

    Connections {
        target: MessagesModel
        onNewMessageArrived: ViewController.trigger("popup:/messages");
    }

    MeikadeLoader {
        parent: form.homePage
        anchors.fill: parent
        active: !AsemanGlobals.testHomeDisable
        visible: form.currentIndex == 0
        onVisibleChanged: if (visible && !AsemanGlobals.testHomeDisable) active = true
        sourceComponent: HomePage {
            anchors.fill: parent
        }
    }

    MeikadeLoader {
        active: false
        parent: form.explorePage
        anchors.fill: parent
        visible: form.currentIndex == 1
        onVisibleChanged: if (visible && !AsemanGlobals.testHomeDisable) active = true
        sourceComponent: ExplorePage {
            anchors.fill: parent
        }
    }

    MeikadeLoader {
        active: false
        parent: form.searchPage
        anchors.fill: parent
        visible: form.currentIndex == 2
        onVisibleChanged: if (visible && !AsemanGlobals.testSearchDisable) active = true
        sourceComponent: SearchPage {
            id: search
            anchors.fill: parent

            Connections {
                target: form
                onCurrentIndexChanged: search.keywordField.focus = false;
                onFooterItemDoubleClicked: if(currentIndex === 2) search.keywordField.forceActiveFocus()
            }
        }
    }

    MeikadeLoader {
        active: false
        parent: form.myMeikadePage
        anchors.fill: parent
        visible: form.currentIndex == 3
        onVisibleChanged: if (visible && !AsemanGlobals.testMyMeikadeDisable) active = true
        sourceComponent: MyMeikadePage {
            anchors.fill: parent
        }
    }

    Connections {
        target: AsemanGlobals
        onIntroDoneChanged: loadChangelogs()
    }

    property Item changelogItem
    onChangelogItemChanged: if (!changelogItem) loadThemeWized()

    function loadChangelogs() {
        if (!Bootstrap.initialized)
            return;
        if (!AsemanGlobals.introDone)
            return;

        if (AsemanGlobals.lastChangelogs >= appVersionNumber)
        {
            loadThemeWized();
            return;
        }

        Tools.jsDelayCall(1000, function(){ changelogItem = Viewport.controller.trigger("float:/changelogs") });
        AsemanGlobals.lastChangelogs = appVersionNumber;
    }

    function loadThemeWized() {
        if (Devices.isAndroid)
            return;
        if (AsemanGlobals.themeDone)
            return;

        Tools.jsDelayCall(400, function(){ Viewport.controller.trigger("bottomdrawer:/settings/theme") });
        AsemanGlobals.themeDone = true;
    }

    Loader {
        anchors.fill: parent
        active: !AsemanGlobals.introDone && !AsemanGlobals.testIntroDisable
        z: 1000
        sourceComponent: IntroPage {
            anchors.fill: parent

            Component.onCompleted: {
                for (var i=0; i<GTranslations.model.count; i++)
                    if (GTranslations.model.get(i).key === AsemanGlobals.language) {
                        welcomForm.languageCombo.currentIndex = i;
                        break;
                    }
            }

            Timer {
                id: initTimer
                repeat: false
                interval: 500
                running: true
            }

            welcomForm.languageCombo.textRole: "title"
            welcomForm.languageCombo.model: GTranslations.model
            welcomForm.languageCombo.onCurrentIndexChanged: if (welcomForm.languageCombo.currentIndex >= 0 && !initTimer.running) AsemanGlobals.language = GTranslations.model.get(welcomForm.languageCombo.currentIndex).key

            doneForm.finishBtn.onClicked: AsemanGlobals.introDone = true;
            doneForm.signInBtn.onClicked: Viewport.controller.trigger("float:/auth/float")
            doneForm.helpBtn.onCheckedChanged: AsemanGlobals.sendData = doneForm.helpBtn.checked
        }
    }
}
