import QtQuick 2.12
import AsemanQml.Viewport 2.0
import logics 1.0

ChangePasswordPage {
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true
    viewport: Viewport.viewport
}
