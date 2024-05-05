import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.0
import components 1.0
import globals 1.0
import "privates"

MPage {
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
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: flickScene.height
        contentWidth: flickScene.width

        Item {
            id: flickScene
            width: flick.width
            height: Math.max(flickColumn.height, flick.height)

            Column {
                id: flickColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                spacing: 8 * Devices.density

                Rectangle {
                    width: parent.width
                    height: 120 * Devices.density
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

                            MButton {
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

                        Column {
                            anchors.centerIn: parent
                            spacing: 4 * Devices.density

                            MLabel {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Last sync date and time") + Translations.refresher
                                font.pixelSize: 9 * Devices.fontDensity
                                font.bold: true
                                color: Colors.accent
                            }

                            MLabel {
                                id: syncDateLabel
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "29 June 2020"
                                font.pixelSize: 8 * Devices.fontDensity
                            }

                            MLabel {
                                id: syncTimeLabel
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "15:01:49"
                                font.pixelSize: 8 * Devices.fontDensity
                            }
                        }
                    }
                }

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20 * Devices.density
                    spacing: 10 * Devices.density

                    MLabel {
                        width: parent.width
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Items you want to sync with Meikade's cloud services:")
                              + Translations.refresher
                        font.pixelSize: 9 * Devices.fontDensity
                    }

                    RowLayout {
                        id: mypoemsRow
                        width: parent.width
                        spacing: 0

                        MLabel {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("My Poems") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        MSwitch {
                            id: mypoemsSwitch
                        }
                    }

                    RowLayout {
                        id: favesRow
                        width: parent.width
                        spacing: 0

                        MLabel {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Lists") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        MSwitch {
                            id: syncListsSwitch
                        }
                    }

                    RowLayout {
                        id: notesRow
                        width: parent.width
                        spacing: 0

                        MLabel {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Notes") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        MSwitch {
                            id: syncNotesSwitch
                        }
                    }

                    RowLayout {
                        id: viewRow
                        width: parent.width
                        spacing: 0

                        MLabel {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Last viewed poems") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        MSwitch {
                            id: syncPoemsSwitch
                        }
                    }

                    RowLayout {
                        id: topPoetsRow
                        width: parent.width
                        spacing: 0

                        MLabel {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Top Poets") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        MSwitch {
                            id: syncTopPoetsSwitch
                        }
                    }

                    Item {
                        width: 1
                        height: 4 * Devices.density
                    }

                    MButton {
                        id: resyncBtn
                        width: parent.width
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

    header: MHeader {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        title: qsTr("Sync") + Translations.refresher

        HeaderBackButton {
            id: closeBtn
        }
    }
}

