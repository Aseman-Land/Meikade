import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0

HafizFaalView {
    width: Constants.width
    height: Constants.height

    selector.backScene: Viewport.viewport
    selector.delegate: PoemPage {
        anchors.fill: parent
        form.menuBtn.onClicked: BackHandler.back()
    }

    closeBtn.onClicked: ViewportType.open = false
}
