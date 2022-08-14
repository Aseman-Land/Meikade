import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import ".."

SearchSmartAboutPage {
    width: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : parent.width
    height: 500 * Devices.density

    cancelBtn.onClicked: ViewportType.open = false
}

