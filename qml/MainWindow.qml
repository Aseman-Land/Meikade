import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.Viewport 2.0
import routes 1.0
import globals 1.0
import components 1.0

AsemanWindow {
    id: mainWin
    width: 400
    height: 700
    visible: true

    property alias viewport: viewport
    property alias mainLoader: mainLoader

    LayoutMirroring.enabled: GTranslations.textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    Component.onCompleted: restoreSize()
    onWidthChanged: storeSize()
    onHeightChanged: storeSize()

    Timer {
        id: initBlocker
        interval: 500
        repeat: false
        running: true
    }

    Viewport {
        id: viewport
        anchors.fill: parent
        mainItem: MeikadeLoader {
            id: mainLoader
            anchors.fill: parent
            active: !testMode
            sourceComponent: MainPage {
                anchors.fill: parent
            }

            readonly property bool lightToolbar: mainLoader.item? mainLoader.item.lightToolbar : false
        }
        Component.onCompleted: ViewController.viewport = viewport
    }

    Snackbar { id: snackbar }

    Connections {
        target: GlobalSignals
        onSnackbarRequest: snackbar.open(text)
    }

    function restoreSize() {
        if (!Devices.isDesktop)
            return;

        width = AsemanGlobals.width
        height = AsemanGlobals.height
        x = screen.width/2 - AsemanGlobals.width/2
        y = screen.height/2 - AsemanGlobals.height/2
    }

    function storeSize() {
        if (!Devices.isDesktop)
            return;
        if (initBlocker.running)
            return;

        AsemanGlobals.width = width
        AsemanGlobals.height = height
    }
}
