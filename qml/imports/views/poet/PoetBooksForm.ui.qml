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
import queries 1.0

Item {
    id: booksList
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias listView: listView
    property alias headerItem: headerItem
    property alias headerBtn: headerBtn
    property alias navigationRepeater: navigationRepeater
    property alias menuBtn: menuBtn
    property alias avatar: avatar
    property alias avatarBtn: avatarBtn
    property alias progressBar: progressBar

    property string premiumMsg

    property bool readWriteMode: false
    property bool poemAddMode: true
    property bool bookAddMode: true

    property real progress: progressBar.progress

    property int poemsCount

    signal navigationClicked(string link, int index)
    signal addBookRequest()
    signal addPoemRequest()
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

    FlexiList {
        id: listView
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        topMargin: 12 * Devices.density

        footer: Item {
            width: listView.width
            height: (readWriteMode? addColumn.height + 40 * Devices.density : 0) + 4 * Devices.density + Devices.navigationBarHeight

            ColumnLayout {
                id: addColumn
                anchors.left: parent.left
                anchors.right: parent.right
                y: 20 * Devices.density
                visible: readWriteMode
                spacing: 4 * Devices.density

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    opacity: 0.8
                    text: premiumMsg
                    visible: premiumMsg.length && poemAddMode
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: Subscription.mypoemsLimits > poemsCount? Colors.foreground : "#a00"

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
                    visible: !addBtn.visible && premiumMsg.length && !AsemanGlobals.disablePremiumMyBooksWarn && Bootstrap.payment && Bootstrap.trusted && poemAddMode
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    visible: !addBtn.visible && premiumMsg.length && !AsemanGlobals.disablePremiumMyBooksWarn && Bootstrap.payment && Bootstrap.trusted && poemAddMode
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
                            onClicked: AsemanGlobals.disablePremiumMyBooksWarn = true
                        }
                    }
                }

                Label {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    text: qsTr("To add new poem please tap on the below button.") + Translations.refresher
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    opacity: 0.7
                    visible: addBtn.visible
                }

                RoundButton {
                    id: addBtn
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: addRow.width + 60 * Devices.density
                    highlighted: true
                    IOSStyle.accent: Colors.accent
                    Material.accent: Colors.accent
                    visible: poemAddMode && (Subscription.mypoemsLimits > poemsCount || premiumMsg.length == 0)

                    Connections {
                        onClicked: addPoemRequest()
                    }

                    RowLayout {
                        id: addRow
                        x: 30 * Devices.density
                        anchors.verticalCenter: parent.verticalCenter

                        Label {
                            font.pixelSize: 12 * Devices.fontDensity
                            font.family: MaterialIcons.family
                            text: MaterialIcons.mdi_feather
                            color: "#fff"
                        }

                        Label {
                            text: qsTr("New Poem") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                            color: "#fff"
                        }
                    }
                }

                Label {
                    visible: bookAddMode
                    Layout.topMargin: poemAddMode? 20 * Devices.density : 0
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    text: qsTr("if you want to add a sub-book category, please tap on the below button.") + Translations.refresher
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    opacity: 0.7
                }

                RoundButton {
                    visible: bookAddMode
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: addSubBookRow.width + 60 * Devices.density
                    highlighted: true

                    Connections {
                        onClicked: addBookRequest()
                    }

                    RowLayout {
                        id: addSubBookRow
                        x: 30 * Devices.density
                        anchors.verticalCenter: parent.verticalCenter

                        Label {
                            font.pixelSize: 12 * Devices.fontDensity
                            font.family: MaterialIcons.family
                            text: MaterialIcons.mdi_notebook
                            color: "#fff"
                        }

                        Label {
                            text: qsTr("New Book") + Translations.refresher
                            font.pixelSize: 9 * Devices.fontDensity
                            color: "#fff"
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
        color: Colors.headerColor
        light: !Colors.lightHeader
        shadow: Devices.isAndroid

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: Devices.statusBarHeight
            spacing: 4 * Devices.density

            HeaderMenuButton {
                id: headerBtn
                ratio: 1
                buttonColor: Colors.headerTextColor
            }

            Item {
                Layout.preferredWidth: 32 * Devices.density
                Layout.preferredHeight: 32 * Devices.density
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                RoundedItem {
                    radius: Constants.radius
                    width: parent.width * 2
                    height: parent.height * 2
                    anchors.centerIn: parent
                    scale: 0.5
                    visible: !AsemanGlobals.testPoetImagesDisable

                    Rectangle {
                        anchors.fill: parent
                        color: Colors.lightHeader? Colors.primary : Colors.headerTextColor
                        visible: avatar.status != Image.Ready
                    }

                    Label {
                        anchors.centerIn: parent
                        color: Colors.headerColor
                        font.pixelSize: 28 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_account
                    }

                    CachedImage {
                        id: avatar
                        anchors.fill: parent
                        sourceSize.width: width * 1.2
                        sourceSize.height: height * 1.2
                        fillMode: Image.PreserveAspectCrop
                    }

                    ItemDelegate {
                        id: avatarBtn
                        anchors.fill: parent
                    }
                }
            }

            Flickable {
                id: navFlick
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 8 * Devices.density
                flickableDirection: Flickable.HorizontalFlick
                contentWidth: navScene.width
                contentHeight: navScene.height
                clip: true

                Item {
                    id: navScene
                    height: navFlick.height
                    width: Math.max(navFlick.width, navRow.width)

                    RowLayout {
                        id: navRow
                        height: parent.height
                        anchors.left: parent.left
                        spacing: 4 * Devices.density

                        Repeater {
                            id: navigationRepeater
                            model: ListModel {
                                ListElement {
                                    title: "Hello"
                                }
                                ListElement {
                                    title: "World"
                                }
                            }

                            RowLayout {
                                spacing: 0
                                Layout.alignment: Qt.AlignVCenter

                                Label {
                                    font.family: MaterialIcons.family
                                    text: LayoutMirroring.enabled? MaterialIcons.mdi_chevron_left : MaterialIcons.mdi_chevron_right
                                    font.pixelSize: 14 * Devices.fontDensity
                                    color: Colors.headerTextColor
                                }

                                Label {
                                    text: model.title
                                    font.pixelSize: 9 * Devices.fontDensity
                                    color: Colors.headerTextColor
                                    maximumLineCount: 1
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    elide: Text.ElideRight

                                    ItemDelegate {
                                        id: navDel
                                        anchors.fill: parent
                                        anchors.margins: -14 * Devices.density
                                        z: -1

                                        Connections {
                                            target: navDel
                                            onClicked: booksList.navigationClicked(model.link, model.index)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            MinimalProgressBar {
                id: progressBar
            }

            ItemDelegate {
                id: menuBtn
                Layout.preferredHeight: Devices.standardTitleBarHeight
                Layout.preferredWidth: Devices.standardTitleBarHeight

                Label {
                    anchors.centerIn: parent
                    font.family: MaterialIcons.family
                    font.pixelSize: 14 * Devices.fontDensity
                    text: MaterialIcons.mdi_dots_vertical
                    color: Colors.headerTextColor
                }
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
