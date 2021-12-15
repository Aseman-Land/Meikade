import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import globals 1.0

Page {
    width: Constants.width
    height: Constants.height

    property alias scene: scene
    property alias flickable: flickable
    property alias progressBar: progressBar
    property alias busyIndicator: busyIndicator
    property alias closeBtn: closeBtn
    property alias bioText: bioText

    Rectangle {
        anchors.fill: parent
        color: Colors.background
    }

    Item {
        id: scene
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom

        AsemanFlickable {
            id: flickable
            anchors.fill: parent
            contentHeight: flickColumn.height
            contentWidth: flickColumn.width
            flickableDirection: Flickable.VerticalFlick

            ColumnLayout {
                id: flickColumn
                width: flickable.width

                Label {
                    id: bioText
                    Layout.margins: 14
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: "Wissen Sie, wie Sie Pensionsrisiken minimieren sowie Pensionsverpflichtungen und #Volatilität reduzieren? Melden Sie sich jetzt an zum Webinar am 12. Mai! "
                }
            }
        }

        HScrollBar {
            anchors.right: flickable.right
            anchors.bottom: flickable.bottom
            anchors.top: flickable.top
            color: Colors.primary
            scrollArea: flickable
        }
    }

    BusyIndicator {
        id: busyIndicator
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        anchors.centerIn: parent
        running: false
    }

    Rectangle {
        id: headerItem
        color: Colors.lightBackground
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Devices.standardTitleBarHeight + Devices.statusBarHeight

        ProgressBar {
            id: progressBar
            indeterminate: true
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            visible: false
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14 * Devices.density
            anchors.rightMargin: 2 * Devices.density
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            Label {
                id: bioTitle
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12 * Devices.fontDensity
                horizontalAlignment: Text.AlignLeft
                text: qsTr("Biography") + Translations.refresher
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
            }

            RoundButton {
                id: closeBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Close") + Translations.refresher
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.foreground: Colors.foreground
                IOSStyle.background: Colors.deepBackground
                Material.foreground: Colors.foreground
                Material.background: Colors.deepBackground
                Material.theme: Material.Dark
                Material.elevation: 0
            }
        }
    }
}
