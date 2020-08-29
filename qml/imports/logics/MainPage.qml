import QtQuick 2.0
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0
import routes 1.0

MainView {
    id: form

    onCurrentIndexChanged: search.keywordField.focus = false;

    readonly property bool firstPage: currentIndex == 0

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
    }

    HomePage {
        parent: form.homePage
        anchors.fill: parent
    }

    SearchPage {
        id: search
        parent: form.searchPage
        anchors.fill: parent
    }

    MyMeikadePage {
        parent: form.myMeikadePage
        anchors.fill: parent
    }

    Connections {
        target: AsemanGlobals
        onIntroDoneChanged: loadChangelogs()
    }

    function loadChangelogs() {
         if (!AsemanGlobals.introDone)
             return;
         if (AsemanGlobals.lastChangelogs >= 410)
             return;

         Tools.jsDelayCall(1000, function(){ Viewport.controller.trigger("float:/changelogs") });
         AsemanGlobals.lastChangelogs = 410;
    }

    Loader {
        anchors.fill: parent
        active: !AsemanGlobals.introDone
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
