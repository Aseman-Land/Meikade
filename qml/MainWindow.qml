import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.IOSStyle 2.3
import logics 1.0
import routes 1.0
import globals 1.0
import micros 1.0

AsemanWindow {
    id: mainWin
    width: 400
    height: 700
    visible: true

    property alias viewport: viewport

    IOSStyle.theme: AsemanGlobals.iosTheme
    Material.theme: AsemanGlobals.androidTheme

    LayoutMirroring.enabled: GTranslations.textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    Viewport {
        id: viewport
        anchors.fill: parent
        mainItem: MainPage {
            anchors.fill: parent
        }
        Component.onCompleted: ViewController.viewport = viewport
    }

    Snackbar { id: snackbar }

    Connections {
        target: GlobalSignals
        onSnackbarRequest: snackbar.open(text)
    }
}
