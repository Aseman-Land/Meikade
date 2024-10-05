import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import globals 1.0
import components 1.0
import models 1.0

Item {
    id: dis
    width: Constants.width
    height: Constants.height
    clip: true

    property alias editArea: editArea
    property alias previewBtn: previewBtn
    property alias saveBtn: saveBtn

    property alias backBtn: backBtn
    property alias flickable: flickable
    property alias coverImage: coverImage
    property alias coverScene: coverScene
    property alias profileLabel: titleLabel
    property alias navigationRepeater: navigationRepeater

    property alias poet: titleLabel.text
    property alias title: subtitleLabel.text
    property alias cover: coverImage.source

    readonly property real ratioAbs: Math.min(ratio, 1)
    readonly property real ratio: Math.max(
                                      0,
                                      coverImage.height + mapListener.result.y
                                      - Devices.standardTitleBarHeight - Devices.statusBarHeight)
                                  / (coverImage.height - Devices.standardTitleBarHeight
                                     - Devices.statusBarHeight)

    property int currentType

    Rectangle {
        anchors.fill: parent
        color: Colors.background
    }

    PointMapListener {
        id: mapListener
        source: scene
        dest: dis
    }

    AsemanFlickable {
        id: flickable
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: toolButtonsRow.top
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height
        clip: true

        EscapeItem {
            id: scene
            width: flickable.width
            height: Math.max(editArea.paintedHeight, flickable.height) + flickable.height/2

            ColumnLayout {
                y: coverImage.height + headerFooter.height + 10 * Devices.density
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20 * Devices.density
                spacing: 4 * Devices.density

                MLabel {
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                    opacity: 0.7
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("To add your poem, please type every verse in a single line. After all verses written press save button.") + Translations.refresher
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 0

                    Repeater {
                        model: 4

                        MButton {
                            Layout.preferredWidth: typeIcon.width + 20 * Devices.density
                            Layout.preferredHeight: typeIcon.height + 20 * Devices.density
                            highlighted: model.index == currentType
                            flat: true
                            onClicked: currentType = model.index

                            PoemTypeIcon {
                                id: typeIcon
                                width: 28 * Devices.density
                                height: 36 * Devices.density
                                x: 10 * Devices.density
                                y: 10 * Devices.density
                                type: model.index
                                color: currentType == model.index? Colors.accent : Colors.foreground
                            }
                        }
                    }
                }

                MLabel {
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                    opacity: 0.7
                    textFormat: Text.StyledText
                    visible: currentType == 0 || currentType == 2
                    text: "<b>" + qsTr("Note") + ":</b> " + qsTr("To make verses showin in center of the line, add a ':' in the first of the line.") + Translations.refresher
                }

                MLabel {
                    Layout.topMargin: 8 * Devices.density
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignLeft
                    color: Colors.primary
                    text: qsTr("Every verse in a single line:") + Translations.refresher
                }

                MTextArea {
                    id: editArea
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                    placeholderText: qsTr("Poem Text") + Translations.refresher

                    Connections {
                        onCursorRectangleChanged: {
                            let r = editArea.cursorRectangle;
                            if (r.y < 50)
                                return;

                            let ry = r.y + editArea.y;
                            if (flickable.contentY >= ry)
                                flickable.contentY = ry;
                            else if (flickable.contentY + flickable.height/2 <= ry + r.height)
                                flickable.contentY = ry + r.height - flickable.height/2;
                        }
                    }
                }
            }
        }

    }

    RowLayout {
        id: toolButtonsRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 10 * Devices.density
        spacing: 4 * Devices.density

        MButton {
            id: previewBtn
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Preview") + Translations.refresher
        }

        MButton {
            id: saveBtn
            font.pixelSize: 9 * Devices.fontDensity
            highlighted: true
            text: qsTr("Save poem") + Translations.refresher
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: flickable.bottom
        anchors.top: flickable.top
        anchors.topMargin: coverImage.height + headerFooter.height
        color: Colors.primary
        scrollArea: flickable
    }

    Item {
        id: coverScene
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
            source: AsemanGlobals.testHeaderImagesDisable? "" : "qrc:/qml/images/views/cover.jpg"

            Rectangle {
                anchors.fill: parent
                color: "#000"
                opacity: (1 - ratioAbs) * 0.3
            }
        }

        Item {
            anchors.fill: parent
            anchors.topMargin: Devices.statusBarHeight

            MLabel {
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

            MLabel {
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

                        MBusyIndicator {
                            scale: 0.6
                            Layout.preferredHeight: 28 * Devices.density
                            Layout.preferredWidth: 28 * Devices.density
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

                                MLabel {
                                    Layout.alignment: Qt.AlignVCenter
                                    font.pixelSize: 12 * Devices.fontDensity
                                    font.family: MaterialIcons.family
                                    text: LayoutMirroring.enabled? MaterialIcons.mdi_chevron_left : MaterialIcons.mdi_chevron_right
                                    color: "#fff"
                                }

                                MLabel {
                                    Layout.alignment: Qt.AlignVCenter
                                    font.pixelSize: 9 * Devices.fontDensity
                                    text: model.title
                                    color: "#fff"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
