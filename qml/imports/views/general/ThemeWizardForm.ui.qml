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

    readonly property bool lightToolbar: Colors.lightHeader

    property alias headerItem: headerItem
    property alias listView: frame.listView
    property alias closeBtn: closeBtn
    property alias applyBtn: applyBtn

    Rectangle {
        anchors.fill: parent
        color: Colors.background
        opacity: 0.5
    }

    ColumnLayout {
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        spacing: 0

        ThemeWizardFrame {
            id: frame
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Button {
            id: applyBtn
            Layout.fillWidth: true
            Layout.bottomMargin: 8 * Devices.density
            Layout.leftMargin: 60 * Devices.density
            Layout.rightMargin: 60 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Apply and Close") + Translations.refresher
            highlighted: true
            Material.accent: Colors.accent
            IOSStyle.accent: Colors.accent
        }
    }

    Rectangle {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: Devices.standardTitleBarHeight
        color: "transparent"

        Separator {}

        Label {
            id: headerLabel
            anchors.centerIn: parent
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Theme Wizard") + Translations.refresher
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: closeBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Close") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                Material.accent: Qt.darker(Colors.primary, 1.3)
                Material.theme: Material.Dark
                IOSStyle.accent: Qt.darker(Colors.primary, 1.3)
                IOSStyle.theme: IOSStyle.Dark
                Material.elevation: 0
            }
        }
    }
}
