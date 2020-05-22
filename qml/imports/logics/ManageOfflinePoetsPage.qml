import QtQuick 2.12
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0

ManageOfflinePoetsView {
    width: Constants.width
    height: Constants.height

    closeBtn.onClicked: ViewportType.open = false
}
