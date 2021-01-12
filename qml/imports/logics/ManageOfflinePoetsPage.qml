import QtQuick 2.12
import AsemanQml.Viewport 2.0
import requests 1.0
import views 1.0
import globals 1.0
import models 1.0

ManageOfflinePoetsView {
    width: Constants.width
    height: Constants.height

    closeBtn.onClicked: ViewportType.open = false

    premiumMsg: {
        if (Subscription.premium || Subscription.offlineLimits < 0 || !Bootstrap.initialized)
            return "";

        var tgLink = "<a href='https://t.me/poshtibanimoon'>" + qsTr("Click Here") +"</a>";
        if (Bootstrap.payment && AsemanGlobals.trusted)
            return GTranslations.translate( qsTr("You install %1 offline poet from %2 poets, Allowed to install using non-premium account.").arg(offlinePoetsCount).arg(Subscription.offlineLimits) );
        else
            return GTranslations.translate( qsTr("You install %1 offline poet from %2 poets. for more information contact us on telegram:").arg(offlinePoetsCount).arg(Subscription.offlineLimits) ) + " " + tgLink;
    }

    onPremiumBuyRequest: Viewport.controller.trigger("bottomdrawer:/account/premium/buy")

    listView.model: {
        switch (tabBar.currentIndex) {
        case 1:
            return catsModel;
        default:
        case 0:
            return poetsModel;
        }
    }

    PoetsCleanModel {
        id: poetsModel
        cachePath: AsemanGlobals.cachePath + "/poetsofflinelist.cache"
    }

    OfflineCatsModel {
        id: catsModel
        cachePath: AsemanGlobals.cachePath + "/catsofflinelist.cache"
    }
}
