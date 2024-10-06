import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import AsemanQml.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import components 1.0
import requests 1.0

Page {
    id: form
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias poemText: poemText.text
    property alias closeBtn: closeBtn
    property alias confirmBtn: confirmBtn
    property alias poemBtn: poemBtn
    property alias helper: helper
    property alias deleteBtn: deleteBtn
    property alias noteField: noteField
    property alias flick: flick
    property alias scene: scene
    property alias premiumBtn: premiumBtn

    property string premiumMsg
    property int currentNotesCount

    readonly property real keyboardHeight: height/3

    signal premiumBuyRequest()

    AsemanFlickable {
        id: flick
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: buttonsRow.top
        contentWidth: scene.width
        contentHeight: scene.height
        flickableDirection: Flickable.VerticalFlick
        clip: true

        EscapeItem {
            id: scene
            width: flick.width
            height: Math.max(flick.height, sceneColumn.height + 20 * Devices.density)

            ColumnLayout {
                id: sceneColumn
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.margins: 10 * Devices.density
                spacing: 10 * Devices.density

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 10 * Devices.density
                    Layout.leftMargin: 10 * Devices.density
                    Layout.rightMargin: 10 * Devices.density
                    spacing: 20 * Devices.density

                    Label {
                        id: poemText
                        Layout.fillWidth: true
                        Layout.minimumHeight: 60 * Devices.density
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 9 * Devices.fontDensity
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        text: "Poem Description" + Translations.refresher

                        BusyIndicator {
                            anchors.centerIn: parent
                            running: poemText.text.length == 0
                        }

                        ItemDelegate {
                            id: poemBtn
                            anchors.fill: parent
                            anchors.margins: -10 * Devices.density
                            z: -1
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10 * Devices.density
                    Layout.rightMargin: 10 * Devices.density
                    height: 1 * Devices.density
                    color: "#33888888"
                }

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    opacity: 0.8
                    text: premiumMsg
                    visible: premiumMsg.length
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: Subscription.notesLimits > currentNotesCount? Colors.foreground : "#a00"

                    Connections {
                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    text: qsTr("To buy premium account click on below button") + Translations.refresher
                    visible: !noteField.visible && premiumMsg.length && !AsemanGlobals.disablePremiumNotesWarn && Bootstrap.payment && Bootstrap.trusted
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    visible: !noteField.visible && premiumMsg.length && !AsemanGlobals.disablePremiumNotesWarn && Bootstrap.payment && Bootstrap.trusted
                    spacing: 0

                    RoundButton {
                        id: premiumBtn
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: form.width * 0.5
                        text: qsTr("Premium Account") + Translations.refresher
                        font.pixelSize: 9 * Devices.fontDensity
                        highlighted: true
                        Material.accent: Subscription.premiumColor
                        IOSStyle.accent: Subscription.premiumColor
                        Material.elevation: 0

                        Connections {
                            target: premiumBtn
                            onClicked: form.premiumBuyRequest()
                        }
                    }

                    RoundButton {
                        id: premiumDisMisBtn
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Don't show this message again") + Translations.refresher
                        font.underline: true
                        font.pixelSize: 8 * Devices.fontDensity
                        flat: true
                        highlighted: true

                        Connections {
                            target: premiumDisMisBtn
                            onClicked: AsemanGlobals.disablePremiumNotesWarn = true
                        }
                    }
                }

                TextArea {
                    id: noteField
                    Layout.fillWidth: true
                    Layout.bottomMargin: keyboardHeight
                    Layout.minimumHeight: 200 * Devices.density
                    placeholderText: qsTr("Type your note") + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    selectByMouse: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    visible: Subscription.notesLimits > currentNotesCount || text.length > 0 || premiumMsg.length == 0
                    onTextChanged: visible = true
                    background: Item {}
                }
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: flick.bottom
        anchors.top: flick.top
        color: Colors.primary
        scrollArea: flick
    }

    RowLayout {
        id: buttonsRow
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10 * Devices.density
        anchors.bottomMargin: Devices.navigationBarHeight + 10 * Devices.density

        Button {
            id: deleteBtn
            Layout.preferredWidth: 50 * Devices.density
            font.pixelSize: 14 * Devices.fontDensity
            font.family: MaterialIcons.family
            text: MaterialIcons.mdi_trash_can
            flat: true
            highlighted: true
            Material.accent: Material.Red
            IOSStyle.accent: IOSStyle.Red
        }

        Button {
            id: confirmBtn
            Layout.fillWidth: true
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Save") + Translations.refresher
            highlighted: true
            Material.accent: Colors.noteButton
            IOSStyle.accent: Colors.noteButton
            Material.elevation: 0
        }
    }

    Helper {
        id: helper
        anchors.fill: parent

        HelperPoint {
            x: parent.width/2
            width: 180 * Devices.density
            height: 180 * Devices.density
            buttonText: qsTr("I Undrestand") + Translations.refresher
            title: qsTr("To go to the poem, click on the verse") + Translations.refresher
        }
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Edit Note") + Translations.refresher
        color: Colors.headerColor
        light: !Colors.lightHeader
        shadow: isAndroidStyle

        HeaderBackButton {
            id: closeBtn
        }
    }
}
