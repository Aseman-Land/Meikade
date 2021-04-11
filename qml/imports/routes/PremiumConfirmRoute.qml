import QtQuick 2.12
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0
import logics 1.0

PremiumConfirmPage {
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true

    x: Viewport.viewport.width/2 - width/2
    width: ViewportType.maximumWidth? ViewportType.maximumWidth : Viewport.viewport.width
}
