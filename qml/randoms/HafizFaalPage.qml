import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import requests 1.0
import components 1.0
import "views"
import "../poems"

HafizFaalView {
    id: dis
    width: Constants.width
    height: Constants.height

    selector.count: 495
    selector.startId: 2130
    selector.delegate: PoemPage {
        anchors.fill: parent
        form.backBtn.onClicked: BackHandler.back()
        poetId: 2
        poet: qsTr("Hafiz") + Translations.refresher
        title: qsTr("%1 Ghazal").arg(Tools.translateNumbers(currentItem)) + Translations.refresher
        image: "https://meikade.com/offlines/thumbs/2.png"
        url: "page:/poet?id=2&poemId=" + poemId

        property int currentItem

        Component.onCompleted: ALogger.log("hafiz.faal", poemId, clock.getMs());
        Component.onDestruction: clock.reset()
    }

    closeBtn.onClicked: ViewportType.open = false

    Clock { id: clock }
}


