import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Layouts 1.3
import globals 1.0
import components 1.0
import requests 1.0

MPage {
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

    property string premiumMsg
    property int currentNotesCount

    readonly property real keyboardHeight: height/3

    signal premiumBuyRequest()

    AsemanFlickable {
        id: flick
        anchors.top: parent.top
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

                    MLabel {
                        id: poemText
                        Layout.fillWidth: true
                        Layout.minimumHeight: 60 * Devices.density
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 9 * Devices.fontDensity
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        text: "Poem Description" + Translations.refresher

                        MBusyIndicator {
                            anchors.centerIn: parent
                            running: poemText.text.length == 0
                        }

                        MItemDelegate {
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

        MButton {
            id: deleteBtn
            Layout.preferredWidth: 50 * Devices.density
            font.pixelSize: 14 * Devices.fontDensity
            font.family: MaterialIcons.family
            text: MaterialIcons.mdi_trash_can
            flat: true
            highlighted: true
        }

        MButton {
            id: confirmBtn
            Layout.fillWidth: true
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Save") + Translations.refresher
            highlighted: true
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
        shadow: Devices.isAndroid

        HeaderBackButton {
            id: closeBtn
        }
    }
}
