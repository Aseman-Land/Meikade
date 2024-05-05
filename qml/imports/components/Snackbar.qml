import QtQuick 2.4
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
import QtQuick.Layouts 1.1
import globals 1.0

Rectangle {
    id: snackbar

    property string buttonText
    property string text
    property bool opened
    property int duration: 2000
    property bool fullWidth: true

    signal clicked

    function open(text) {
        snackbar.text = text
        opened = true;
        timer.restart();
    }

    anchors {
        left: fullWidth ? parent.left : undefined
        right: fullWidth ? parent.right : undefined
        bottom: parent.bottom
        bottomMargin: opened ? 0 :  -snackbar.height
        horizontalCenter: fullWidth ? undefined : parent.horizontalCenter

        Behavior on bottomMargin {
            NumberAnimation { duration: 300 }
        }
    }
    radius: fullWidth ? 0 : 2 * Devices.density
    color: Colors.primary
    height: snackLayout.height
    width: fullWidth ? undefined : snackLayout.width
    opacity: opened ? 1 : 0

    Timer {
        id: timer

        interval: snackbar.duration

        onTriggered: {
            if (!running) {
                snackbar.opened = false;
            }
        }
    }

    RowLayout {
        id: snackLayout

        anchors {
            verticalCenter: parent.verticalCenter
            left: snackbar.fullWidth ? parent.left : undefined
            right: snackbar.fullWidth ? parent.right : undefined
        }

        spacing: 0

        Item {
            width: 24 * Devices.density
        }

        MLabel {
            id: snackText
            font.pixelSize: 9*Devices.fontDensity
            Layout.fillWidth: true
            Layout.minimumWidth: snackbar.fullWidth ? -1 : 216 * Devices.fontDensity - snackButton.width
            Layout.maximumWidth: snackbar.fullWidth ? -1 :
                Math.min(496 * Devices.fontDensity - snackButton.width - middleSpacer.width - 48 * Devices.fontDensity,
                         snackbar.parent.width - snackButton.width - middleSpacer.width - 48 * Devices.fontDensity)

            Layout.preferredHeight: lineCount == 2 ? 80 * Devices.density : 48 * Devices.density
            verticalAlignment: Text.AlignVCenter
            maximumLineCount: 2
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            text: snackbar.text
            color: "#fff"
        }

        Item {
            id: middleSpacer
            width: snackbar.buttonText == "" ? 0 : snackbar.fullWidth ? 24 * Devices.density : 48 * Devices.density
        }

        MButton {
            id: snackButton
            flat: true
            visible: snackbar.buttonText != ""
            text: snackbar.buttonText
            onClicked: snackbar.clicked()
        }

        Item {
            width: 24 * Devices.density
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 300 }
    }
}
