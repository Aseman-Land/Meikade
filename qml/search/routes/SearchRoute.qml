import QtQuick 2.12
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0
import ".."

SearchPage {
    ViewportType.maximumWidth: tabletWidth
    ViewportType.touchToClose: true
    closeBtn.visible: true
    closeBtn.onClicked: ViewportType.open = false
}

