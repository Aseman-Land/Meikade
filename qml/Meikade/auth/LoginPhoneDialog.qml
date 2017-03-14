import AsemanTools 1.1
import AsemanTools.Awesome 1.0
import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "."
import "../globals"

Dialog {
    id: login2Dialog
    title: qsTr("Login")
    x: parent.width/2 - width/2
    y: parent.height/2 - height/2
    dim: true
    modal: true

    ColumnLayout {

        Button {
            text: qsTr("Google Account")
            highlighted: true
        }

        Item {
            Layout.preferredHeight: 20*Devices.density
        }

        Label {
            text: qsTr("Using phone")
            font.bold: true
            Layout.preferredWidth: phoneField.Layout.preferredWidth
        }

        TextField {
            id: phoneField
            Layout.preferredWidth: login2Dialog.parent.width - 100*Devices.density
            placeholderText: qsTr("Phone")
            inputMethodHints: Qt.ImhNoPredictiveText
            validator: RegExpValidator{regExp: /\d+/i }
        }
        Button {
            text: qsTr("Login")
            highlighted: true
            flat: true
            Layout.preferredWidth: phoneField.Layout.preferredWidth
        }
    }

    function clear() {
        phoneField.clear()
    }
}
