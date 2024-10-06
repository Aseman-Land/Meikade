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
import queries 1.0
import models 1.0

Item {
    id: dis
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property string keyword
    property alias listView: listView
    property alias headerItem: headerItem
    property alias menuBtn: menuBtn
    property alias closeBtn: closeBtn

    property int offlinePoetsCount

    signal checked(string poetId, variant properties, bool active)

    Rectangle {
        anchors.fill: parent
        color: Colors.deepBackground
    }

    ReloadItem {
        id: busyIndicator
        anchors.centerIn: parent
        viewItem: listView
    }

    Label {
        anchors.centerIn: parent
        font.pixelSize: 8 * Devices.fontDensity
        text: qsTr("There is no item here") + Translations.refresher
        visible: listView.count == 0 && !busyIndicator.running
        opacity: 0.6
    }

    AsemanListView {
        id: listView
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        topMargin: 4 * Devices.density
        bottomMargin: 4 * Devices.density

        header: Item {
            width: listView.width
            height: headerColumns.height

            ColumnLayout {
                id: headerColumns
                width: parent.width - 16 * Devices.density
                x: 8 * Devices.density
                anchors.bottom: parent.bottom
                spacing: 4 * Devices.density

                TextField {
                    id: searchKeyword
                    Layout.fillWidth: true
                    Layout.preferredHeight: 46 * Devices.density
                    horizontalAlignment: Text.AlignLeft
                    placeholderText: qsTr("Search") + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    onTextChanged: dis.keyword = text
                }
            }
        }

        delegate: Item {
            id: itemObj
            width: listView.width
            height: rowLayout.height + 20 * Devices.density

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
                    onClicked: swt.toggle()
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
                                ignoreSslErrors: AsemanGlobals.ignoreSslErrors
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
                            text: model.title
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

                    MinimalProgressBar {
                        id: progressBar
                        color: Colors.deepBackground
                        frontColor: Colors.accent
                        textColor: "#333"
                        running: offlineInstaller.downloading || offlineInstaller.installing || offlineInstaller.uninstalling
                        label: offlineInstaller.uninstalling? qsTr("Uninstalling") : (offlineInstaller.downloading? qsTr("Downloading") : qsTr("Installing"))
                        nonProgress: !offlineInstaller.uninstalling
                        progress: offlineInstaller.size? 0.1 + 0.9 * offlineInstaller.downloadedBytes / offlineInstaller.size : 0.1
                    }

                    Switch {
                        id: swt
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        enabled: !offlineInstaller.installing || offlineInstaller.uninstalling
                        checked: (offlineInstaller.installed || offlineInstaller.installing || offlineInstaller.downloading) && !offlineInstaller.uninstalling

                        property bool initialized: false
                        Component.onCompleted: initialized = true

                        onToggled: {
                            if (swt.checked == (offlineInstaller.installed || offlineInstaller.downloading))
                                return;

                            if (offlineInstaller.downloading)
                                offlineInstaller.stop();
                            else {
                                offlinePoetsCount = offlineInstaller.checkCount();
                                var res = offlineInstaller.checkAndInstall(swt.checked);
                                if (swt.checked) {
                                    if (res)
                                        offlinePoetsCount++;
                                    else
                                        swt.checked = false;
                                } else {
                                    offlinePoetsCount--;
                                }
                            }
                        }
                        onInitializedChanged: if (model.index == 0) offlinePoetsCount = offlineInstaller.checkCount();

                        DataOfflineInstaller {
                            id: offlineInstaller
                            poetId: model.id
                            catId: model.catId
                        }
                    }
                }
            }
        }
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Manage Shelf") + Translations.refresher
        color: Colors.headerColor
        light: !Colors.lightHeader
        shadow: isAndroidStyle

        HeaderBackButton {
            id: closeBtn
        }

        HeaderMenuButton {
            id: menuBtn
            ratio: 1
            buttonColor: Colors.headerTextColor
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        color: Colors.primary
        scrollArea: listView
    }
}
