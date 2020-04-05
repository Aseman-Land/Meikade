import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Awesome 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls 2.3 as QtControls
import QtQuick.Controls.Material 2.3
import "pages" as Pages
import "globals"

AsemanWindow {
    id: mainWin
    width: 500
    height: 820
    visible: true

    Timer {
        id: waitTimer
        interval: 1000
        repeat: false
        running: true
    }

    Viewport {
        id: viewport
        anchors.fill: parent
        mainItem: Pages.MainPage {
            anchors.fill: parent
        }
        Component.onCompleted: ViewController.viewport = viewport
    }

    Rectangle {
        anchors.fill: parent
        color: Material.primary
        visible: waitTimer.running

        BusyIndicator {
            anchors.centerIn: parent
            Material.accent: "#fff"
        }
    }

    Item {
        id: upperArea
        anchors.fill: parent
    }

    QtControls.Dialog {
        id: errorDialog
        anchors.centerIn: parent
        standardButtons: QtControls.Dialog.Ok
        modal: true
        dim: true

        property alias message: messageLabel.text

        Label {
            id: messageLabel
            font.pixelSize: 9 * Devices.fontDensity
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            width: mainWin.width * 0.9
        }

        Component.onCompleted: GlobalObjects.errorDialog = errorDialog
    }
}
