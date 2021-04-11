import QtQuick 2.12
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0
import logics 1.0
import globals 1.0

ThemeWizardPage {
    width: Viewport.viewport.width
    height: 480 * Devices.density
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true
}
