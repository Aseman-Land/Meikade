import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import QtQuick.Controls 2.9
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.0
import globals 1.0

Page {
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias syncDateLabel: syncDateLabel
    property alias syncTimeLabel: syncTimeLabel
    property alias mypoemsSwitch: mypoemsSwitch
    property alias syncListsSwitch: syncListsSwitch
    property alias syncNotesSwitch: syncNotesSwitch
    property alias syncPoemsSwitch: syncPoemsSwitch
    property alias syncTopPoetsSwitch: syncTopPoetsSwitch
    property alias syncIndicator: syncIndicator
    property alias syncBtn: syncBtn
    property alias closeBtn: closeBtn
    property alias resyncBtn: resyncBtn

    AsemanFlickable {
        id: flick
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        flickableDirection: Flickable.VerticalFlick
        contentHeight: flickScene.height
        contentWidth: flickScene.width

        Item {
            id: flickScene
            width: flick.width
            height: Math.max(flickColumn.height, flick.height)

            ColumnLayout {
                id: flickColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120 * Devices.density
                    color: Colors.deepBackground

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 10 * Devices.density
                        anchors.leftMargin: 20 * Devices.density
                        anchors.rightMargin: 20 * Devices.density
                        radius: Constants.radius
                        color: Colors.background

                        Item {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 40 * Devices.density

                            Button {
                                id: syncBtn
                                anchors.centerIn: parent
                                highlighted: true
                                flat: true
                                width: 50 * Devices.density
                                height: width
                                font.family: MaterialIcons.family
                                font.pixelSize: 14 * Devices.fontDensity
                                text: MaterialIcons.mdi_reload
                                visible: !syncIndicator.running
                            }

                            BusyIndicator {
                                id: syncIndicator
                                anchors.centerIn: parent
                            }
                        }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4 * Devices.density

                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                text: qsTr("Last sync date and time") + Translations.refresher
                                font.pixelSize: 9 * Devices.fontDensity
                                font.bold: true
                                color: Colors.accent
                            }

                            Label {
                                id: syncDateLabel
                                Layout.alignment: Qt.AlignHCenter
                                text: "29 June 2020"
                                font.pixelSize: 8 * Devices.fontDensity
                            }

                            Label {
                                id: syncTimeLabel
                                Layout.alignment: Qt.AlignHCenter
                                text: "15:01:49"
                                font.pixelSize: 8 * Devices.fontDensity
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.margins: 12 * Devices.density
                    spacing: 0

                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Items you want to sync with Meikade's cloud services:")
                              + Translations.refresher
                        font.pixelSize: 9 * Devices.fontDensity
                    }

                    RowLayout {
                        id: mypoemsRow
                        spacing: 0

                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("My Poems") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        Switch {
                            id: mypoemsSwitch
                        }
                    }

                    RowLayout {
                        id: favesRow
                        spacing: 0

                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Lists") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        Switch {
                            id: syncListsSwitch
                        }
                    }

                    RowLayout {
                        id: notesRow
                        spacing: 0

                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Notes") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        Switch {
                            id: syncNotesSwitch
                        }
                    }

                    RowLayout {
                        id: viewRow
                        spacing: 0

                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Last viewed poems") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        Switch {
                            id: syncPoemsSwitch
                        }
                    }

                    RowLayout {
                        id: topPoetsRow
                        spacing: 0

                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Top Poets") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        Switch {
                            id: syncTopPoetsSwitch
                        }
                    }

                    Button {
                        id: resyncBtn
                        Layout.fillWidth: true
                        Layout.topMargin: 20 * Devices.density
                        highlighted: true
                        font.pixelSize: 9 * Devices.fontDensity
                        text: qsTr("Resync All") + Translations.refresher
                    }
                }
            }
        }
    }

    HScrollBar {
        scrollArea: flick
        anchors.right: flick.right
        anchors.top: flick.top
        anchors.bottom: flick.bottom
        color: Colors.primary
    }

    Header {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        text: qsTr("Sync") + Translations.refresher
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
