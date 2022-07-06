import QtQuick 2.12
import globals 1.0
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0
import ".."

SingleListPage {
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true
    width: parent.width
    height: Viewport.viewport.height * 0.7
    onCloseRequest: ViewportType.open = false;
}

