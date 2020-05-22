import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0

HafizFaalView {
    id: dis
    width: Constants.width
    height: Constants.height

    selector.count: 495
    selector.startId: 2130
    selector.backScene: Viewport.viewport
    selector.delegate: PoemPage {
        anchors.fill: parent
        form.menuBtn.onClicked: BackHandler.back()
        poetId: 2
        poet: qsTr("Hafiz") + Translations.refresher
        title: qsTr("%1 Ghazal").arg(currentItem) + Translations.refresher
        poetImage: "https://meikade.com/offlines/thumbs/2.png"
        url: "page:/poet?id=2&poemId=" + poemId
        properties: {
            "color": "",
            "poet": poet,
            "heightRatio": 0.6,
            "type": "fullback",
            "moreHint": false,
        }

        property int currentItem
    }

    closeBtn.onClicked: ViewportType.open = false
}
