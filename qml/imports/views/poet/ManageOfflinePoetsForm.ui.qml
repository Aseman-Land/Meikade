import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import requests 1.0
import globals 1.0
import micros 1.0
import queries 1.0
import models 1.0

Item {
    id: dis
    width: Constants.width
    height: Constants.height

    property alias listView: listView
    property alias headerItem: headerItem
    property alias closeBtn: closeBtn
    property alias tabBar: tabBar

    property string premiumMsg
    property int offlinePoetsCount

    signal clicked(string link, variant properties)

    signal premiumBuyRequest()

    Rectangle {
        anchors.fill: parent
        color: Colors.deepBackground
    }

    ReloadItem {
        id: busyIndicator
        anchors.centerIn: parent
        viewItem: listView
    }

    AsemanListView {
        id: listView
        anchors.top: tabBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        topMargin: 4 * Devices.density
        bottomMargin: 4 * Devices.density

        header: Item {
            width: listView.width
            height: headerRow.visible? headerRow.height + 30 * Devices.density : 0

            ColumnLayout {
                id: headerRow
                y: 15 * Devices.density
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10 * Devices.density
                visible: premiumMsg.length

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    opacity: 0.8
                    text: premiumMsg
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: Subscription.offlineLimits > offlinePoetsCount? Colors.foreground : "#a00"
                }

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    text: qsTr("To buy premium account click on below button") + Translations.refresher
                    visible: Subscription.offlineLimits <= offlinePoetsCount && !AsemanGlobals.disablePremiumOfflinesWarn && Bootstrap.payment
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    visible: Subscription.offlineLimits <= offlinePoetsCount && !AsemanGlobals.disablePremiumOfflinesWarn && Bootstrap.payment
                    spacing: 0

                    RoundButton {
                        id: premiumBtn
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: listView.width * 0.5
                        text: qsTr("Premium Account") + Translations.refresher
                        font.pixelSize: 9 * Devices.fontDensity
                        highlighted: true
                        Material.accent: Subscription.premiumColor
                        IOSStyle.accent: Subscription.premiumColor
                        Material.elevation: 0

                        Connections {
                            target: premiumBtn
                            onClicked: dis.premiumBuyRequest()
                        }
                    }

                    RoundButton {
                        id: premiumDisMisBtn
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Don't show this message again") + Translations.refresher
                        font.underline: true
                        font.pixelSize: 8 * Devices.fontDensity
                        flat: true
                        highlighted: true

                        Connections {
                            target: premiumDisMisBtn
                            onClicked: AsemanGlobals.disablePremiumOfflinesWarn = true
                        }
                    }
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

                    Connections {
                        target: itemDel
                        onClicked: swt.toggle()
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

                            CachedImage {
                                anchors.fill: parent
                                sourceSize.width: 92 * Devices.density
                                sourceSize.height: 92 * Devices.density
                                asynchronous: true
                                source: model.image
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

                        Connections {
                            target: swt
                            onCheckedChanged: {
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
                        }

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

    Rectangle {
        anchors.fill: tabBar
        color: Colors.deepBackground
    }

    TabBar {
        id: tabBar
        anchors.top: headerItem.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        TabButton {
            text: qsTr("Poets") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
        }
        TabButton {
            text: qsTr("Books") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
        }
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Manage Offlines") + Translations.refresher
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

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        color: Colors.primary
        scrollArea: listView
    }
}
