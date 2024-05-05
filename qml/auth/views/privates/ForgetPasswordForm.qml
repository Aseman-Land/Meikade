import QtQuick 2.12
import globals 1.0
import components 1.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.Controls 2.0

MPage {
    id: page
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias cancelBtn: cancelBtn
    property alias headerItem: headerItem
    property alias sendBtn: sendBtn
    property alias userTxt: userTxt
    property alias loginLabel: loginLabel
    property alias backgroudMouseArea: backgroudMouseArea

    AsemanFlickable {
        id: flickable
        anchors.fill: parent
        contentWidth: scene.width
        contentHeight: scene.height

        Item {
            id: scene
            width: flickable.width
            height: flickable.height

            MouseArea {
                id: backgroudMouseArea
                anchors.fill: parent
            }

            Column {
                id: columnLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20 * Devices.density
                spacing: 8 * Devices.density

                MLabel {
                    id: loginLabel
                    font.pixelSize: 9 * Devices.fontDensity
                    text: qsTr("To restore your password please enter your username below and tap on the restore. We'll send an email to you to change your password.") + Translations.refresher
                    width: parent.width
                    wrapMode: Text.WordWrap
                }

                MTextField {
                    id: userTxt
                    width: parent.width
                    placeholderText: qsTr("Username") + Translations.refresher
                    font.pixelSize: 10 * Devices.fontDensity
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhNoAutoUppercase
                    onAccepted: sendBtn.focus = true

                    MLabel {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        anchors.margins: 8 * Devices.density
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_account
                        color: Colors.primary
                    }
                }

                MButton {
                    id: sendBtn
                    text: qsTr("Restore") + Translations.refresher
                    width: parent.width
                    font.pixelSize: 9 * Devices.fontDensity
                    highlighted: true
//                    enabled: userTxt.length > 5 && passTxt.length > 5
                }
            }
        }
    }

    MHeader {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        title: qsTr("Forget Password") + Translations.refresher

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            MButton {
                id: cancelBtn
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 8 * Devices.density
                text: qsTr("Cancel") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
            }
        }
    }
}
