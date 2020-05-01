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
        mainItem: MainPage {
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
            IOSStyle.foreground: "#fff"
        }
    }

    Item {
        id: upperArea
        anchors.fill: parent
    }
}
