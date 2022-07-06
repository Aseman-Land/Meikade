import QtQuick 2.12
import globals 1.0
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0
import ".."

ChangelogsPage {
    width: Constants.width
    height: Constants.height
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true
}

