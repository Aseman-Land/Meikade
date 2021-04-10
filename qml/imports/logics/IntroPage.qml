import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import requests 1.0
import views 1.0
import globals 1.0
import models 1.0

IntroView {
    id: home

    nextBtn.enabled: list.currentIndex != 1 || topHomeModel.count > 4

    Component.onCompleted: Tools.jsDelayCall(1000, function(){ setupThemeForm.listView.currentIndex = 0 })

    TopPoetsHomeModel {
        id: topHomeModel
    }

    Timer {
        id: stopTimer
        interval: 800
        repeat: false
        running: true
    }

    setupHomeForm {
        listView.model: TopPoetsModel {
            id: topModel
        }

        onChecked: {
            if (active)
                topModel.append(poetId, properties);
            else
                topModel.remove(poetId);
        }
    }

    setupThemeForm {
        listView.onCurrentIndexChanged: {
            if (stopTimer.running)
                return;

            var listView = setupThemeForm.listView;
            var item = listView.model.get(listView.currentIndex);

            AsemanGlobals.mixedHeaderColor = !item.configColorToolbar;
            if (isAndroidStyle) {
                switch (item.configTheme) {
                case 0:
                    AsemanGlobals.androidTheme = Material.Light;
                    break;
                case 1:
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

    setupOfflinesForm {

        premiumMsg: {
            if (Subscription.premium || Subscription.offlineLimits < 0 || !Bootstrap.initialized)
                return "";

            var tgLink = "<a href='https://t.me/poshtibanimoon'>" + qsTr("Click Here") +"</a>";
            if (Bootstrap.payment && Bootstrap.trusted)
                return GTranslations.translate( qsTr("You install %1 offline poet from %2 poets, Allowed to install using non-premium account.").arg(setupOfflinesForm.offlinePoetsCount).arg(Subscription.offlineLimits) );
            else
                return GTranslations.translate( qsTr("You install %1 offline poet from %2 poets. for more information contact us on telegram:").arg(setupOfflinesForm.offlinePoetsCount).arg(Subscription.offlineLimits) ) + " " + tgLink;
        }

        onPremiumBuyRequest: Viewport.controller.trigger("bottomdrawer:/account/premium/buy")

        listView.model: PoetsCleanModel {
            id: poetsModel
        }
    }
}
