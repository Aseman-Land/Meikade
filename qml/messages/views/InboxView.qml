import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import components 1.0
import models 1.0
import requests 1.0

Page {
    id: dis
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias headerItem: headerItem
    property alias closeBtn: closeBtn
    property alias inboxModel: listView.model

    ReloadItem {
        id: busyIndicator
        anchors.centerIn: parent
        viewItem: listView
    }

    AsemanListView {
        id: listView
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        clip: true
        model: 20

        section.property: "categories"
        section.criteria: ViewSection.FullString
        section.delegate: Item {
            width: listView.width
            height: sectionLabel.text.length? 40 * Devices.density : 0
            opacity: sectionLabel.text.length? 1 : 0

            Label {
                id: sectionLabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 8 * Devices.density
                anchors.bottomMargin: 4 * Devices.density
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 9 * Devices.fontDensity
                text: section
                color: Colors.accent
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

        delegate: ItemDelegate {
            id: sugItem
            width: listView.width
            height: rowLyt.height + 12 * Devices.density

            RowLayout {
                id: rowLyt
                anchors.left: parent.left
                anchors.right: parent.right
                y: 6 * Devices.density
                anchors.rightMargin: 10 * Devices.density
                spacing: 4 * Devices.density

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 50 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.family: MaterialIcons.family
                    font.pixelSize: 16 * Devices.fontDensity
                    text: MaterialIcons[model.icon]
                    color: model.color
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        font.pixelSize: 9 * Devices.fontDensity
                        text: model.title
                    }

                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        font.pixelSize: 8 * Devices.fontDensity
                        opacity: 0.7
                        text: model.body
                        color: model.color
                    }

                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        font.pixelSize: 8 * Devices.fontDensity
                        opacity: 0.7
                        visible: text.length
                        text: model.description
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
        shadow: isAndroidStyle

        HeaderBackButton {
            id: closeBtn
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
