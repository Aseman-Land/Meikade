import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import micros 1.0

Page {
    id: dis
    width: Constants.width
    height: Constants.height

    property alias listView: listView
    property alias nextBtn: nextBtn

    readonly property real headerHeight: 200 * Devices.density
    readonly property real ratio: 1 - Math.min( Math.max(-headerListener.result.y / listView.headerItem.height, 0), 1)

    signal checked(string poetId, variant properties, bool active)

    PointMapListener {
        id: headerListener
        source: listView.headerItem
        dest: dis
    }

    ReloadItem {
        id: busyIndicator
        anchors.centerIn: parent
        viewItem: listView
    }

    AsemanListView {
        id: listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: nextBtn.top
        clip: true
        model: 50
        bottomMargin: Devices.standardTitleBarHeight + 6 * Devices.density
        header: Item {
            width: listView.width
            height: headerHeight
        }

        delegate: Item {
            id: itemObj
            width: listView.width
            height: rowLayout.height + 20 * Devices.density

            property bool isVerse: model.details && model.details.first_verse? true : false

            RoundedItem {
                anchors.fill: parent
                anchors.leftMargin: 8 * Devices.density
                anchors.rightMargin: 8 * Devices.density
                anchors.topMargin: 4 * Devices.density
                anchors.bottomMargin: 4 * Devices.density
                radius: Constants.radius / 2

                Rectangle {
                    anchors.fill: parent
                    color: Colors.background
                }

                ItemDelegate {
                    id: itemDel
                    anchors.fill: parent

                    Connections {
                        target: itemDel
                        onClicked: delSwitch.checked = !delSwitch.checked
                    }
                }

                RowLayout {
                    id: rowLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10 * Devices.density
                    spacing: 10 * Devices.density

                    Item {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.preferredHeight: 38 * Devices.density
                        Layout.preferredWidth: 38 * Devices.density

                        RoundedItem {
                            width: parent.width * 2
                            height: parent.height * 2
                            anchors.centerIn: parent
                            radius: Constants.radius * 1.5
                            scale: 0.5
                            visible: !AsemanGlobals.testPoetImagesDisable

                            CachedImage {
                                anchors.fill: parent
                                sourceSize.width: 92 * Devices.density
                                sourceSize.height: 92 * Devices.density
                                asynchronous: true
                                source: AsemanGlobals.testPoetImagesDisable? "" : model.image
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2 * Devices.density

                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            font.pixelSize: 9 * Devices.fontDensity
                            text: model.title + (itemObj.isVerse? " - " + model.details.first_verse : "")
                        }

                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            font.pixelSize: 8 * Devices.fontDensity
                            opacity: 0.8
                            text: model.subtitle
                            visible: text.length
                        }
                    }

                    Switch {
                        id: delSwitch
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        checked: model.checked

                        Connections {
                            target: delSwitch
                            onCheckedChanged: {
                                model.checked = delSwitch.checked;
                                dis.checked(model.id, listView.model.get(index), delSwitch.checked);
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: Devices.standardTitleBarHeight * 2 + Devices.statusBarHeight

        gradient: Gradient {
            GradientStop { position: 0.6; color: Colors.background }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    Item {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Devices.standardTitleBarHeight + Devices.statusBarHeight + (headerHeight - Devices.standardTitleBarHeight + Devices.statusBarHeight) * ratio

        Item {
            anchors.fill: parent
            anchors.topMargin: Devices.statusBarHeight

            ColumnLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: ratio * 10 +  2 * Devices.density

                Label {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    font.pixelSize: 10 * Devices.fontDensity
                    text: qsTr("Setup Favorites") + Translations.refresher
                    scale: ratio * 0.8 + 1
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 9 * Devices.fontDensity
                    text: qsTr("Please choose at lease 3 your favorites.") + Translations.refresher
                    scale: ratio*0.2 + 1
                    opacity: 0.8
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: nextBtn.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Devices.standardTitleBarHeight
        gradient: Gradient {
            GradientStop { position: 0; color: "transparent" }
            GradientStop { position: 1; color: Colors.background }
        }
    }

    Button {
        id: nextBtn
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: Devices.navigationBarHeight + Devices.standardTitleBarHeight
        width: 300 * Devices.density
        text: qsTr("Next") + Translations.refresher
        font.pixelSize: 9 * Devices.fontDensity
        highlighted: true
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        anchors.topMargin: headerHeight
        color: Colors.primary
        scrollArea: listView
    }
}
