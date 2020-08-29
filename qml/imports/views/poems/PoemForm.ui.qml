import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0
import models 1.0

Item {
    id: dis
    width: Constants.width
    height: Constants.height
    clip: true

    property alias backBtn: backBtn
    property alias viewsLabel: viewsLabel
    property alias listView: listView
    property alias coverImage: coverImage
    property alias coverScene: coverScene
    property alias profileLabel: titleLabel
    property alias searchBtn: searchBtn
    property alias menuBtn: menuBtn
    property alias menuBtnPosition: menuBtnListener.result
    property alias navigationRepeater: navigationRepeater
    property alias statusBarRect: statusBarRect

    property string viewCount
    property alias poet: titleLabel.text
    property alias title: subtitleLabel.text
    property alias cover: coverImage.source
    property string phrase

    property bool headerVisible: true

    property bool selectMode
    property real selectModeAnimRatio: selectMode? 1 : 0
    property variant selectedList: new Array

    property int highlightItemIndex: -1
    property real highlighItemRatio: 0

    readonly property real ratioAbs: Math.min(ratio, 1)
    readonly property real ratio: Math.max(
                                      0,
                                      coverImage.height + mapListener.result.y
                                      - Devices.standardTitleBarHeight - Devices.statusBarHeight)
                                  / (coverImage.height - Devices.standardTitleBarHeight
                                     - Devices.statusBarHeight)

    signal navigationClicked(string link, int index)
    signal menuRequest(int index, variant object)
    signal selectedToggled(int index, bool selected)

    Connections {
        target: dis
        onSelectModeChanged: if (!selectMode) selectedList = new Array
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.background
    }

    PointMapListener {
        id: menuBtnListener
        source: menuBtn
        dest: dis
    }

    PointMapListener {
        id: mapListener
        source: listView.headerItem
        dest: dis

        Connections {
            target: mapListener
            onResultChanged: {
                var contentY = mapListener.result.y
                if(contentY > -coverImage.height - 100 * Devices.density)
                    headerVisible = true;
                else {
                    var delta = (contentY-mapListener.lastY)
                    if(delta > 100*Devices.density)
                        headerVisible = true;
                    else
                    if(delta < -50*Devices.density)
                        headerVisible = false;
                }
            }
        }

        property real lastY
    }

    ReloadItem {
        id: busyIndicator
        anchors.centerIn: parent
        viewItem: listView
    }

    AsemanListView {
        id: listView
        anchors.fill: parent

        onDraggingVerticallyChanged: if (draggingVertically) mapListener.lastY = mapListener.result.y

        model: 40

        header: Item {
            width: listView.width
            height: coverImage.height + headerFooter.height + 10 * Devices.density
        }

        delegate: Item {
            id: del
            width: listView.width
            height: verseLabel.height + 20 * Devices.density
            z: 100000 - index

            Rectangle {
                anchors.fill: itemDel
                visible: highlightItemIndex == model.index
                opacity: highlighItemRatio * 0.2
                color: "#f00"
            }

            CheckBox {
                id: checkbox
                anchors.verticalCenter: model.position === PoemVersesModel.PositionRight? parent.bottom : parent.verticalCenter
                anchors.left: delFrame.right
                checked: selectedList[model.index] && selectedList.length? selectedList[model.index] : false
                visible: selectMode && model.position !== PoemVersesModel.PositionLeft && model.position !== PoemVersesModel.PositionCenteredVerse2

                Connections {
                    target: checkbox
                    onCheckedChanged: {
                        selectedList[model.index] = checkbox.checked
                        dis.selectedToggled(model.index, checkbox.checked);
                    }
                }
                Connections {
                    target: dis
                    onSelectModeChanged: checkbox.checked = false
                }
            }

            Rectangle {
                anchors.fill: itemDel
                visible: itemDel.pressed
                opacity: 0.1
                color: Colors.foreground
            }

            MouseArea {
                id: itemDel
                height: model.position === PoemVersesModel.PositionRight || model.position === PoemVersesModel.PositionCenteredVerse1 ||
                        model.position === PoemVersesModel.PositionLeft || model.position === PoemVersesModel.PositionCenteredVerse2? delFrame.height * 2 : delFrame.height
                anchors.left: parent.left
                anchors.right: parent.right
                y: model.position === PoemVersesModel.PositionLeft || model.position === PoemVersesModel.PositionCenteredVerse2? delFrame.height - height : 0
                pressAndHoldInterval: 300

                Connections {
                    target: itemDel
                    onPressAndHold: {
                        dis.menuRequest(model.index, delFrame)
                    }
                    onClicked: {
                        dis.selectMode = true;
                        checkbox.checked = !checkbox.checked;
                    }
                }
            }

            Item {
                id: delFrame
                width: parent.width - checkbox.width * selectModeAnimRatio
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                Label {
                    id: verseLabel
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: model.position === PoemVersesModel.PositionRight || model.position === PoemVersesModel.PositionCenteredVerse1? 4 * Devices.density :
                                                  (model.position === PoemVersesModel.PositionLeft || model.position === PoemVersesModel.PositionCenteredVerse2? -4 * Devices.density :
                                                  0)
                    anchors.margins: 20 * Devices.density
                    text: model.text
                    font.pixelSize: 10 * Devices.fontDensity + (AsemanGlobals.fontSize - 3) * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: model.position === PoemVersesModel.PositionRight? Text.AlignRight : (model.position === PoemVersesModel.PositionLeft? Text.AlignLeft
                                         : (model.position === PoemVersesModel.PositionCenteredVerse1 || model.position === PoemVersesModel.PositionCenteredVerse2? Text.AlignHCenter
                                         : Text.AlignRight))

                    LayoutMirroring.enabled: false
                    LayoutMirroring.childrenInherit: true
                }
            }
        }

        footer: Item {
            width: listView.width
            height: phrase.length? phraseColumn.height + 40 * Devices.density + Devices.navigationBarHeight : 0

            ColumnLayout {
                id: phraseColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10 * Devices.density + Devices.navigationBarHeight
                spacing: 4 * Devices.density
                visible: phrase.length

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10 * Devices.density

                    Label {
                        font.pixelSize: 10 * Devices.fontDensity
                        text: qsTr("Phrase") + Translations.refresher
                    }

                    Rectangle {
                        Layout.preferredHeight: 1 * Devices.density
                        Layout.fillWidth: true
                        color: Colors.foreground
                    }
                }

                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: 9 * Devices.fontDensity
                    text: phrase
                }
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        anchors.topMargin: coverImage.height + headerFooter.height
        color: Colors.primary
        scrollArea: listView
    }

    Item {
        id: coverScene
        y: headerVisible? 0 : -Devices.standardTitleBarHeight
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: -1
        height: Math.max(
                    Math.min(coverImage.height,
                             mapListener.result.y + coverImage.height),
                    Devices.standardTitleBarHeight + Devices.statusBarHeight)
        clip: true

        Image {
            id: coverImage
            y: Math.min(0, Math.max(mapListener.result.y / 2, (Devices.standardTitleBarHeight + Devices.statusBarHeight - height)/2))
            anchors.left: parent.left
            anchors.right: parent.right
            height: 210 * Devices.density + Devices.statusBarHeight
            sourceSize.width: width * 1.2
            sourceSize.height: height * 1.2
            fillMode: Image.PreserveAspectCrop
            source: "../images/cover.jpg"

            Rectangle {
                anchors.fill: parent
                color: "#000"
                opacity: (1 - ratioAbs) * 0.3
            }
        }

        Item {
            anchors.fill: parent
            anchors.topMargin: Devices.statusBarHeight

            Label {
                id: titleLabel
                anchors.bottom: subtitleLabel.top
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 10 * Devices.fontDensity
                color: "#fff"
                text: "Bardia Daneshvar"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
                opacity: ratio
            }

            Label {
                id: subtitleLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 10 * Devices.density * ratioAbs
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 14 * Devices.fontDensity
                scale: Math.min(1, (10 + 4 * ratio) / 14)
                color: "#fff"
                text: "High Mountains of QML"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
            }

            Label {
                id: viewsLabel
                anchors.top: subtitleLabel.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 8 * Devices.fontDensity
                color: "#fff"
                text: viewCount + " " + qsTr("Views")
                visible: viewCount.length
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
                opacity: ratio
            }
        }

        Label {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: Devices.statusBarHeight
            width: height
            height: Devices.standardTitleBarHeight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "#fff"
            font.pixelSize: 16 * Devices.fontDensity
            font.family: MaterialIcons.family
            text: MaterialIcons.mdi_magnify

            ItemDelegate {
                id: searchBtn
                anchors.fill: parent
                z: -1
            }
        }

        HeaderMenuButton {
            id: backBtn
            ratio: 1
        }
    }

    Rectangle {
        id: headerFooter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: coverScene.bottom
        anchors.topMargin: -1 * Devices.density
        height: 30 * Devices.density
        color: Qt.lighter(Colors.primary)

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: headerFooter.height * 2
            anchors.rightMargin: -1 * Devices.density

            Flickable {
                id: navFlick
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: 8 * Devices.density
                flickableDirection: Flickable.HorizontalFlick
                contentWidth: navScene.width
                contentHeight: navFlick.height

                Item {
                    id: navScene
                    anchors.verticalCenter: parent.verticalCenter
                    height: headerFooter.height
                    width: Math.max(navFlick.width, navRow.width)

                    RowLayout {
                        id: navRow
                        height: parent.height
                        anchors.left: parent.left
                        spacing: 4 * Devices.density

                        BusyIndicator {
                            scale: 0.6
                            Layout.preferredHeight: 28 * Devices.density
                            Layout.preferredWidth: 28 * Devices.density
                            Material.accent: "#fff"
                            IOSStyle.foreground: "#fff"
                            running: navigationRepeater.model && navigationRepeater.model.refreshing !== undefined && navigationRepeater.model.refreshing && navigationRepeater.count == 0? true : false
                            visible: running
                        }

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
                                    Layout.alignment: Qt.AlignVCenter
                                    font.pixelSize: 12 * Devices.fontDensity
                                    font.family: MaterialIcons.family
                                    text: LayoutMirroring.enabled? MaterialIcons.mdi_chevron_left : MaterialIcons.mdi_chevron_right
                                    color: "#fff"
                                }

                                Label {
                                    Layout.alignment: Qt.AlignVCenter
                                    font.pixelSize: 9 * Devices.fontDensity
                                    text: model.title
                                    color: "#fff"

                                    ItemDelegate {
                                        id: navDel
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        height: headerFooter.height
                                        anchors.margins: -4 * Devices.density

                                        Connections {
                                            target: navDel
                                            onClicked: dis.navigationClicked(model.link, model.index)
                                        }

                                    }
                                }
                            }
                        }
                    }
                }
            }

            ItemDelegate {
                id: menuBtn
                Layout.preferredWidth: 30 * Devices.density
                Layout.preferredHeight: headerFooter.height
                Layout.alignment: Qt.AlignVCenter

                Rectangle {
                    anchors.fill: parent
                    z: -1
                    rotation: LayoutMirroring.enabled? 90 : -90
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 0.7; color: headerFooter.color }
                    }
                }

                Label {
                    anchors.centerIn: parent
                    font.pixelSize: 12 * Devices.fontDensity
                    font.family: MaterialIcons.family
                    text: MaterialIcons.mdi_dots_vertical
                    color: "#fff"
                }
            }
        }
    }

    Rectangle {
        id: statusBarRect
        anchors.left: parent.left
        anchors.right: parent.right
        height: Devices.statusBarHeight
        color: Colors.primary
        opacity: headerVisible? 0 : 1
    }
}
