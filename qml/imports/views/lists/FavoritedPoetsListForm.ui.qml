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

Item {
    id: dis
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias listView: listView
    property alias headerItem: headerItem
    property alias headerTitle: headerTitle
    property alias headerProvider: headerProvider
    property alias headerBusyIndicator: headerBusyIndicator
    property alias closeBtn: closeBtn
    property alias backBtn: backBtn
    property alias followBtn: followBtn
    property alias helper: helper
    property bool publicList: false
    property string listColor: "transparent"
    property color gradientColor: listColor
    property bool publicIndicatorState: false

    property bool followState
    property bool favoriteMode: false
    property bool flatList: false
    property bool onlineList: false
    property bool disableSharing: false

    signal clicked(int index)
    signal publicListSwitch(bool checked)
    signal colorSwitch(string color)
    signal flatListSwitched(bool state)

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
            height: publicColumn.visible? publicColumn.height + 4 * Devices.density : 0

            ColumnLayout {
                id: publicColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: !(disableSharing || favoriteMode) && Bootstrap.initialized
                spacing: 4 * Devices.density

                ItemDelegate {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40 * Devices.density

                    Connections {
                        onClicked: publicSwitch.checked = !publicSwitch.checked
                    }

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 10 * Devices.density

                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Public list") + Translations.refresher
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 9 * Devices.fontDensity
                        }

                        BusyIndicator {
                            id: publicIndicator
                            scale: 0.6
                            Layout.preferredWidth: 28 * Devices.density
                            Layout.preferredHeight: 28 * Devices.density
                            running: publicIndicatorState
                        }

                        Switch {
                            id: publicSwitch
                            checked: publicList
                            enabled: !publicIndicator.running

                            Connections {
                                onCheckedChanged: dis.publicListSwitch(publicSwitch.checked)
                            }
                        }
                    }
                }

                RowLayout {
                    id: colorsRow
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 0 * Devices.density
                    visible: publicSwitch.checked

                    Repeater {
                        model: ListModel {
                            ListElement {
                                color: "transparent"
                            }
                            ListElement {
                                color: "#55aaff"
                            }
                            ListElement {
                                color: "#ffaa00"
                            }
                            ListElement {
                                color: "#00aa7f"
                            }
                            ListElement {
                                color: "#ff557f"
                            }
                            ListElement {
                                color: "#aa007f"
                            }
                        }

                        RoundButton {
                            Layout.preferredHeight: 36 * Devices.density
                            Layout.preferredWidth: 36 * Devices.density
                            radius: width / 2
                            highlighted: model.index != 0
                            IOSStyle.accent: model.color
                            Material.accent: model.color

                            Connections {
                                onClicked: {
                                    listColor = model.color;
                                    dis.colorSwitch(listColor);
                                }
                            }

                            Label {
                                anchors.centerIn: parent
                                font.family: MaterialIcons.family
                                font.pixelSize: 12 * Devices.fontDensity
                                color: model.index == 0? Colors.foreground : "#fff"
                                text: MaterialIcons.mdi_check
                                visible: listColor == model.color
                            }
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
                        onClicked: dis.clicked(model.index)
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
                                ignoreSslErrors: AsemanGlobals.ignoreSslErrors
                                source: AsemanGlobals.testPoetImagesDisable? "" : model.image
                            }
                        }

                        Rectangle {
                            anchors.horizontalCenter: parent.left
                            anchors.verticalCenter: parent.bottom
                            width: 14 * Devices.density
                            height: width
                            radius: 4 * Devices.density
                            color: Colors.background
                            visible: flatList

                            Label {
                                anchors.centerIn: parent
                                font.family: MaterialIcons.family
                                font.pixelSize: 7 * Devices.fontDensity
                                color: listColor.length && listColor != "transparent"? listColor : Colors.primary
                                text: flatList? (model.isVerse? MaterialIcons.mdi_text_short : MaterialIcons.mdi_format_columns) : ""
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
                            text: flatList? model.title + " - " + model.verseText : model.poet
                        }

                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            font.pixelSize: 8 * Devices.fontDensity
                            opacity: 0.8
                            text: flatList? model.poet : model.subtitle
                        }
                    }

                    Label {
                        font.family: MaterialIcons.family
                        font.pixelSize: 16 * Devices.fontDensity
                        text: LayoutMirroring.enabled? MaterialIcons.mdi_chevron_left : MaterialIcons.mdi_chevron_right
                        opacity: 0.4
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

        ColumnLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            y: Devices.statusBarHeight + Devices.standardTitleBarHeight/2 - height/2
            spacing: 0

            Label {
                id: headerTitle
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 10 * Devices.fontDensity
                text: qsTr("Favoriteds") + Translations.refresher
            }
            Label {
                id: headerProvider
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 7 * Devices.fontDensity
                opacity: 0.7
                visible: text.length
            }
        }

        RowLayout {
            anchors.right: parent.right
            anchors.rightMargin: 2 * Devices.density
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight
            spacing: -6 * Devices.density

            RoundButton {
                id: flatBtn
                text: MaterialIcons.mdi_view_list
                font.family: MaterialIcons.family
                radius: 6 * Devices.density
                font.pixelSize: 10 * Devices.fontDensity
                IOSStyle.foreground: flatList? Colors.accent : Colors.foreground
                IOSStyle.background: Colors.deepBackground
                Material.foreground: flatList? Colors.accent : Colors.foreground
                Material.background: Colors.deepBackground
                Material.theme: Material.Dark
                Material.elevation: 0
                visible: !favoriteMode

                Connections {
                    onClicked: {
                        flatList = !flatList;
                        flatListSwitched(flatList);
                    }
                }
            }

            RoundButton {
                id: followBtn
                text: followState? qsTr("Unfollow") : qsTr("Follow") + Translations.refresher
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                highlighted: true
                visible: onlineList
                IOSStyle.accent: followState? IOSStyle.Red : Colors.accent
                Material.accent: followState? Material.Red : Colors.accent
                Material.theme: Material.Dark
                Material.elevation: 0
            }

            RoundButton {
                id: closeBtn
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

        BusyIndicator {
            id: headerBusyIndicator
            anchors.verticalCenter: backBtn.verticalCenter
            anchors.left: backBtn.right
            scale: 0.6
            width: 28 * Devices.density
            height: 28 * Devices.density
            running: false
        }

        HeaderMenuButton {
            id: backBtn
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

    Helper {
        id: helper
        anchors.fill: parent

        HelperPoint {
            x: flatBtn.x + flatBtn.width/2 - width/2
            y: Devices.statusBarHeight + flatBtn.height/2 - height/2
            width: 100 * Devices.density
            height: 100 * Devices.density
            buttonText: qsTr("Next") + Translations.refresher
            title: qsTr("To view all poems without grouping by poets use this button.") + Translations.refresher
        }

        HelperPoint {
            x: closeBtn.x + closeBtn.width/2 - width/2
            y: Devices.statusBarHeight + Devices.standardTitleBarHeight + closeBtn.height/2 - height/2
            width: 100 * Devices.density
            height: 100 * Devices.density
            buttonText: qsTr("I Undrestand") + Translations.refresher
            title: qsTr("To share your list with other users using search area, active this switch.") + Translations.refresher
        }
    }
}
