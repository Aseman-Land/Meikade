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
import requests 1.0

Page {
    id: dis
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias headerItem: headerItem
    property alias closeBtn: closeBtn
    property alias suggestionsModel: listView.model

    AsemanListView {
        id: listView
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        clip: true
        model: 20

        delegate: ItemDelegate {
            id: sugItem
            width: listView.width
            height: 50 * Devices.density

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10 * Devices.density
                spacing: 4 * Devices.density

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 50 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.family: MaterialIcons.family
                    font.pixelSize: 14 * Devices.fontDensity
                    text: MaterialIcons.mdi_bank
                    color: Colors.accent
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        font.pixelSize: 9 * Devices.fontDensity
                        text: qsTr("Text") + " " + model.index + Translations.refresher
                    }

                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        font.pixelSize: 8 * Devices.fontDensity
                        opacity: 0.7
                        text: qsTr("Its a description") + Translations.refresher
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1 * Devices.density
                color: Colors.foreground
                opacity: 0.1
            }
        }
    }

    HScrollBar {
        scrollArea: listView
        anchors.top: listView.top
        anchors.bottom: listView.bottom
        anchors.right: listView.right
        color: Colors.primary
        visible: listView.visible
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Inbox") + Translations.refresher
        color: Colors.headerColor
        light: !Colors.lightHeader
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

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        color: "#fff"
        scrollArea: listView
    }
}
