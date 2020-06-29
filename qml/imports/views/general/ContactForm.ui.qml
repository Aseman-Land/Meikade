import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0
import models 1.0

Item {
    id: dis
    width: Constants.width
    height: Constants.height

    property alias headerItem: headerItem
    property alias closeBtn: closeBtn
    property alias nameField: nameField
    property alias emailField: emailField
    property alias messageField: messageField
    property alias attachSwitch: attachSwitch
    property alias detailsText: detailsText
    property alias sendBtn: sendBtn

    AsemanFlickable {
        id: flick
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height

        Item {
            id: scene
            width: flick.width
            height: Math.max(sceneColumn.height + 20 * Devices.density,
                             flick.height)

            ColumnLayout {
                id: sceneColumn
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 10 * Devices.density
                anchors.margins: 10 * Devices.density
                spacing: 0

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("Fee\ls free and write what you want for us. Messages will sends ananymously if you leaves name and email forms empty.") + Translations.refresher
                    Layout.bottomMargin: 10 * Devices.density
                }

                Label {
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: qsTr("Name") + ":" + Translations.refresher
                }

                TextField {
                    id: nameField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    validator: RegExpValidator { regExp: /\w+/ }
                    Layout.bottomMargin: 10 * Devices.density
                }

                Label {
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: qsTr("Email") + ":" + Translations.refresher
                }

                TextField {
                    id: emailField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    validator: RegExpValidator { regExp: /\w(\w|\.)+\@\w+(\.\w+)+/ }
                    Layout.bottomMargin: 10 * Devices.density
                }

                Label {
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: qsTr("Message") + ":" + Translations.refresher
                }

                TextArea {
                    id: messageField
                    Layout.fillWidth: true
                    Layout.minimumHeight: 100 * Devices.density
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 9 * Devices.fontDensity
                    Layout.bottomMargin: 10 * Devices.density
                    selectByMouse: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        text: qsTr("Attach device details") + Translations.refresher
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                    }

                    Switch {
                        id: attachSwitch
                    }
                }

                Label {
                    id: detailsText
                    Layout.fillWidth: true
                    font.pixelSize: 8 * Devices.fontDensity
                    opacity: attachSwitch.checked? 0.8 : 0.3
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: "Device details: test"
                    Layout.bottomMargin: 10 * Devices.density
                }

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: 8 * Devices.fontDensity
                    text: (attachSwitch.checked? qsTr("Device details will send.") : qsTr("Device details will not sent. Please send it if you are reporting a problem.")) + Translations.refresher
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: attachSwitch.checked? "#18f" : "#a00"
                }

                Button {
                    id: sendBtn
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    highlighted: true
                    text: qsTr("Send") + Translations.refresher
                }
            }
        }
    }

    HScrollBar {
        scrollArea: flick
        anchors.top: flick.top
        anchors.bottom: flick.bottom
        anchors.right: flick.right
        color: Colors.primary
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Contact us") + Translations.refresher
        color: Colors.primary
        shadow: Devices.isAndroid

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14 * Devices.density
            anchors.rightMargin: 2 * Devices.density
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: closeBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Close") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.accent: Qt.darker(Colors.primary, 1.3)
                Material.accent: Qt.darker(Colors.primary, 1.3)
                Material.theme: Material.Dark
                Material.elevation: 0
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: flick.bottom
        anchors.top: flick.top
        color: "#fff"
        scrollArea: flick
    }
}
