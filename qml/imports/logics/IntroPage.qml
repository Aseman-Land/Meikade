import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0
import models 1.0

IntroView {
    id: home

    nextBtn.enabled: list.currentIndex != 1 || topHomeModel.count > 4

    TopPoetsHomeModel {
        id: topHomeModel
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

    setupOfflinesForm {

        premiumMsg: {
            if (Premium.premium || Premium.offlineLimits < 0)
                return "";
            return qsTr("You install %1 offline poet from %2 poets, Allowed to install using non-premium account.").arg(setupOfflinesForm.offlinePoetsCount).arg(Premium.offlineLimits);
        }

        onPremiumBuyRequest: Viewport.controller.trigger("bottomdrawer:/account/premium/buy")

        listView.model: PoetsCleanModel {
            id: poetsModel
        }
    }
}
