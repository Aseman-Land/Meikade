import QtQuick 2.12
import logics 1.0
import globals 1.0
import AsemanQml.Viewport 2.0

WebBrowserPage {
    width: Constants.width
    height: Constants.height
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true
}
