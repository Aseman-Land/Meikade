import QtQuick 2.12
import globals 1.0
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import AsemanQml.Controls 2.0

Page {
    id: page
    width: Constants.width
    height: Constants.height
    property alias headerItem: headerItem
    property alias scene: scene

    property alias cancelBtn: cancelBtn
    property alias loginLabel: loginLabel
    property alias fnameTxt: fnameTxt
    property alias lnameTxt: lnameTxt
    property alias sendBtn: sendBtn
    property alias backgroudMouseArea: backgroudMouseArea

    AsemanFlickable {
        id: flickable
        anchors.fill: parent
        contentWidth: scene.width
        contentHeight: scene.height + Devices.keyboardHeight

        Item {
            id: scene
            width: flickable.width
            height: flickable.height

            MouseArea {
                id: backgroudMouseArea
                anchors.fill: parent
            }

            ColumnLayout {
                id: columnLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20 * Devices.density
                spacing: 20 * Devices.density

                Label {
                    id: loginLabel
                    text: qsTr("Type your phone number for us. We will send you a code for logging into the Meikade.") + Translations.refresher
                    Layout.fillWidth: true
                    Layout.bottomMargin: 20 * Devices.density
                    wrapMode: Text.WordWrap
                }

                TextField {
                    id: fnameTxt
                    Layout.fillWidth: true
                    placeholder: qsTr("First Name") + Translations.refresher
                    font.pixelSize: 15 * Devices.density
                    horizontalAlignment: Text.AlignLeft
                    inputMethodHints: Qt.ImhNoPredictiveText
                }

                TextField {
                    id: lnameTxt
                    Layout.fillWidth: true
                    placeholder: qsTr("Last Name") + Translations.refresher
                    font.pixelSize: 15 * Devices.density
                    horizontalAlignment: Text.AlignLeft
                    inputMethodHints: Qt.ImhNoPredictiveText
                }

                Button {
                    id: sendBtn
                    text: qsTr("Sign Up") + Translations.refresher
                    Layout.bottomMargin: 20 * Devices.density
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    highlighted: true
                    enabled: fnameTxt.length > 2 && lnameTxt.length > 2
                }
            }
        }
    }

    Header {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Signup") + Translations.refresher
        color: Colors.header

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: cancelBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Cancel") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.accent: Qt.darker(Colors.header, 1.3)
                Material.accent: Qt.darker(Colors.header, 1.3)
                Material.theme: Material.Dark
                Material.elevation: 0
            }
        }
    }
}



