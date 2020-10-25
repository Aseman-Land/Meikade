import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import AsemanQml.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0

Page {
    id: form
    width: Constants.width
    height: Constants.height

    property alias poemText: poemText.text
    property alias closeBtn: closeBtn
    property alias confirmBtn: confirmBtn
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
        anchors.bottom: confirmBtn.top
        contentWidth: scene.width
        contentHeight: scene.height
        flickableDirection: Flickable.VerticalFlick
        clip: true

        Item {
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
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 9 * Devices.fontDensity
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        text: "Poem Description" + Translations.refresher
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
                    color: Premium.notesLimits > currentNotesCount? Colors.foreground : "#a00"
                }

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    text: qsTr("To buy premium account click on below button") + Translations.refresher
                    visible: !noteField.visible && premiumMsg.length
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                RoundButton {
                    id: premiumBtn
                    Layout.preferredWidth: form.width * 0.5
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Premium Account") + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    highlighted: true
                    visible: !noteField.visible && premiumMsg.length
                    Material.accent: Premium.packageColor
                    IOSStyle.accent: Premium.packageColor
                    Material.elevation: 0

                    Connections {
                        target: premiumBtn
                        onClicked: form.premiumBuyRequest()
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
                    visible: Premium.notesLimits > currentNotesCount || text.length > 0 || premiumMsg.length == 0
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

    Button {
        id: confirmBtn
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10 * Devices.density
        font.pixelSize: 9 * Devices.fontDensity
        text: qsTr("Save") + Translations.refresher
        highlighted: true
        Material.accent: Colors.noteButton
        IOSStyle.accent: Colors.noteButton
        Material.elevation: 0
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Edit Note") + Translations.refresher
        color: Colors.header
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
}
