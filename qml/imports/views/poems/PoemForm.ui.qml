import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import micros 1.0
import models 1.0

Item {
    id: myMeikade
    width: Constants.width
    height: Constants.height
    property alias menuBtn: menuBtn
    property alias viewsLabel: viewsLabel
    property alias gridView: gridView
    property alias coverImage: coverImage
    property alias coverScene: coverScene
    property alias profileLabel: titleLabel
    property alias settingsBtn: settingsBtn
    property alias navigationRepeater: navigationRepeater

    property alias poet: titleLabel.text
    property alias title: subtitleLabel.text
    property bool headerVisible: true

    readonly property real ratioAbs: Math.min(ratio, 1)
    readonly property real ratio: Math.max(
                                      0,
                                      coverImage.height + mapListener.result.y
                                      - Devices.standardTitleBarHeight - Devices.statusBarHeight)
                                  / (coverImage.height - Devices.standardTitleBarHeight
                                     - Devices.statusBarHeight)

    Rectangle {
        anchors.fill: parent
        color: Colors.deepBackground
    }

    PointMapListener {
        id: mapListener
        source: gridView.headerItem
        dest: myMeikade

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

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: gridView.model && gridView.model.refreshing !== undefined && gridView.model.refreshing && gridView.count == 0
    }

    ListView {
        id: gridView
        anchors.fill: parent

        onDraggingVerticallyChanged: if (draggingVertically) mapListener.lastY = mapListener.result.y

        model: 40

        header: Item {
            width: gridView.width
            height: coverImage.height + headerFooter.height + 10 * Devices.density
        }

        delegate: Item {
            id: del
            width: gridView.width
            height: verseLabel.height + 10 * Devices.density

            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: true

            ItemDelegate {
                height: model.position === PoemVersesModel.PositionRight || model.position === PoemVersesModel.PositionCenteredVerse1 ||
                        model.position === PoemVersesModel.PositionLeft || model.position === PoemVersesModel.PositionCenteredVerse2? del.height * 2 : del.height
                anchors.left: parent.left
                anchors.right: parent.right
                y: model.position === PoemVersesModel.PositionLeft || model.position === PoemVersesModel.PositionCenteredVerse2? del.height - height : 0
            }

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
                font.pixelSize: 10 * Devices.fontDensity
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment: model.position === PoemVersesModel.PositionRight? Text.AlignRight : (model.position === PoemVersesModel.PositionLeft? Text.AlignLeft
                                     : (model.position === PoemVersesModel.PositionCenteredVerse1 || model.position === PoemVersesModel.PositionCenteredVerse2? Text.AlignHCenter
                                     : Text.AlignRight))
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: gridView.bottom
        anchors.top: gridView.top
        anchors.topMargin: coverImage.height + headerFooter.height
        color: Colors.primary
        scrollArea: gridView
    }

    Item {
        id: coverScene
        y: headerVisible? 0 : -Devices.standardTitleBarHeight
        anchors.left: parent.left
        anchors.right: parent.right
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
            height: width * 9 / 20 + Devices.statusBarHeight
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
                font.pixelSize: 10 * Devices.fontDensity
                color: Material.background
                text: "Bardia Daneshvar"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: subtitleLabel.top
                anchors.bottomMargin: 8 * Devices.density
                opacity: ratio
            }

            Label {
                id: subtitleLabel
                font.pixelSize: 14 * Devices.fontDensity
                scale: Math.min(1, (10 + 4 * ratio) / 14)
                color: Material.background
                text: "High Mountains of QML"
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 10 * Devices.density * ratioAbs
            }

            Label {
                id: viewsLabel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: subtitleLabel.bottom
                anchors.topMargin: 10 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                color: Material.background
                text: "500 views in last week"
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
                id: settingsBtn
                anchors.fill: parent
                z: -1
            }
        }

        HeaderMenuButton {
            id: menuBtn
            ratio: 1
        }
    }

    Rectangle {
        id: headerFooter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: coverScene.bottom
        height: 30 * Devices.density
        color: Qt.lighter(Colors.primary)

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8 * Devices.density

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
                        text: MaterialIcons.mdi_chevron_right
                        color: "#fff"
                    }

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        font.pixelSize: 9 * Devices.fontDensity
                        text: model.title
                        color: "#fff"
                    }
                }
            }

            Label {
                Layout.fillWidth: true
            }

            ItemDelegate {
                Layout.fillHeight: true
                Layout.preferredWidth: 30 * Devices.density

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
}
