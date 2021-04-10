import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0
import queries 1.0
import requests 1.0

Page {
    id: homeForm
    width: Constants.width
    height: Constants.height

    property alias listView: listView

    property string premiumMsg
    property int offlinePoetsCount

    readonly property real headerHeight: headColumn.height + 40 * Devices.density
    readonly property real ratio: 1 - Math.min( Math.max(-headerListener.result.y / listView.headerItem.height, 0), 1)

    signal premiumBuyRequest()

    PointMapListener {
        id: headerListener
        source: listView.headerItem
        dest: homeForm
    }

    ReloadItem {
        id: busyIndicator
        anchors.centerIn: parent
        viewItem: listView
    }

    AsemanListView {
        id: listView
        anchors.fill: parent
        model: 50
        bottomMargin: Devices.standardTitleBarHeight * 2

        header: Item {
            width: listView.width
            height: headerHeight + (headerRow.visible? headerRow.height + 30 * Devices.density : 0)

            ColumnLayout {
                id: headerRow
                anchors.bottomMargin: 15 * Devices.density
                anchors.bottom: parent.bottom
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

                    Connections {
                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    text: qsTr("To buy premium account click on below button") + Translations.refresher
                    visible: Subscription.offlineLimits <= offlinePoetsCount && Bootstrap.payment && Bootstrap.trusted
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                RoundButton {
                    id: premiumBtn
                    Layout.preferredWidth: listView.width * 0.5
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Premium Account") + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    highlighted: true
                    visible: Subscription.offlineLimits <= offlinePoetsCount && Bootstrap.payment && Bootstrap.trusted
                    Material.accent: Subscription.premiumColor
                    IOSStyle.accent: Subscription.premiumColor
                    Material.elevation: 0

                    Connections {
                        target: premiumBtn
                        onClicked: homeForm.premiumBuyRequest()
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
        height: Devices.statusBarHeight + Devices.standardTitleBarHeight

        Item {
            anchors.fill: parent
            anchors.topMargin: Devices.statusBarHeight

            ColumnLayout {
                id: headColumn
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 4 * Devices.density
                spacing: 10 * Devices.density

                Label {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    font.pixelSize: 16 * Devices.fontDensity
                    scale: 0.6 + ratio * 0.4
                    text: qsTr("Offline Poets") + Translations.refresher
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 9 * Devices.fontDensity
                    transformOrigin: Item.Top
                    opacity: ratio * 0.8
                    scale: 0.5 + ratio * 0.5
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: qsTr("If you prefer to view some poems offline, Please mark them in the below list to download them.") + Translations.refresher
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: Devices.standardTitleBarHeight * 2 + Devices.statusBarHeight
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: Colors.background }
        }
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
