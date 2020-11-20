import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import logics 1.0

SearchSmartAboutPage {
    width: parent.width
    height: 500 * Devices.density

    cancelBtn.onClicked: ViewportType.open = false
}
