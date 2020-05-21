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
    property alias bioText: bioText
    property alias bioTitle: bioTitle
    property alias bioBtn: bioBtn
    property alias gridView: gridView
    property alias coverImage: coverImage
    property alias avatarBtn: avatarBtn
    property alias avatar: avatar
    property alias profileLabel: profileLabel
    property alias settingsBtn: settingsBtn
    property alias downloadProgressLabel: downloadProgressLabel
    property alias downloadingProgressIndicator: downloadingProgressIndicator
    property alias downloadProgressBar: downloadProgressBar

    property alias title: profileLabel.text
    property alias image: avatar.source

    readonly property real ratioAbs: Math.min(ratio, 1)
    readonly property real ratio: Math.max(
                                      0,
                                      coverImage.height + mapListener.result.y
                                      - Devices.standardTitleBarHeight - Devices.statusBarHeight)
                                  / (coverImage.height - Devices.standardTitleBarHeight
                                     - Devices.statusBarHeight)

    property real downloadProgress: 0.3

    Rectangle {
        anchors.fill: parent
        color: Colors.deepBackground
    }

    PointMapListener {
        id: mapListener
        source: gridView.headerItem
        dest: myMeikade
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: gridView.model && gridView.model.refreshing !== undefined && gridView.model.refreshing && gridView.count == 0
    }

    FlexiList {
        id: gridView
        anchors.fill: parent

        model: PoetModel {}

        header: Item {
            width: gridView.width
            height: coverImage.height + 10 * Devices.density
        }

        footer: Item {
            width: gridView.width
            height: poetBioBack.height + 10 * Devices.density
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: gridView.bottom
        anchors.top: gridView.top
        anchors.topMargin: coverImage.height
        anchors.bottomMargin: Devices.standardTitleBarHeight
        color: Colors.primary
        scrollArea: gridView
    }

    Item {
        id: poetBioScene
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: Math.max(Math.min(poetBioBack.height,
                                  mapListener.result.y + poetBioBack.height),
                         Devices.standardTitleBarHeight)

        Rectangle {
            id: poetBioBack
            anchors.left: parent.left
            anchors.right: parent.right
            height: 100 * Devices.density
            color: Colors.lightBackground
        }

        ItemDelegate {
            id: bioBtn
            anchors.fill: parent
            hoverEnabled: false
        }

        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 14 * Devices.density
            anchors.rightMargin: 14 * Devices.density
            spacing: 0

            Label {
                id: bioTitle
                Layout.fillWidth: true
                Layout.preferredHeight: Devices.standardTitleBarHeight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12 * Devices.fontDensity
                horizontalAlignment: Text.AlignLeft
                text: qsTr("Biography") + Translations.refresher
            }

            Label {
                id: bioText
                Layout.fillWidth: true
                font.pixelSize: 9 * Devices.fontDensity
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "Wissen Sie, wie Sie Pensionsrisiken minimieren sowie Pensionsverpflichtungen und #Volatilität reduzieren? Melden Sie sich jetzt an zum Webinar am 12. Mai! "
            }
        }

        Separator {
            anchors.bottom: parent.top
        }
    }

    Item {
        id: coverScene
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
            height: width * 5 / 10
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

            Item {
                height: Devices.standardTitleBarHeight
                width: height
                x: ratioAbs * (coverImage.width/2 - width/2) + (1 - ratioAbs) * (LayoutMirroring.enabled? parent.width - width - Devices.standardTitleBarHeight + 10 * Devices.density : Devices.standardTitleBarHeight - 10 * Devices.density)
                y: ratioAbs * (coverImage.height/2 - height + 5 * Devices.density)
                scale: (34 + 16 * ratioAbs) / 50

                RoundedItem {
                    anchors.centerIn: parent
                    width: 100 * Devices.density
                    height: 100 * Devices.density
                    scale: 0.5
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    radius: Constants.radius

                    Rectangle {
                        anchors.fill: parent
                        color: Colors.background
                    }

                    Label {
                        anchors.centerIn: parent
                        color: Colors.primary
                        font.pixelSize: 36 * Devices.fontDensity
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

            Label {
                id: profileLabel
                font.pixelSize: 14 * Devices.fontDensity
                scale: (10 + 4 * ratio) / 14
                color: Material.background
                text: "Bardia Daneshvar"
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 30 * Devices.density * ratioAbs
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: profileLabel.bottom
                anchors.topMargin: 8 * Devices.density
                width: downloadingProgressRow.width + 20 * Devices.density
                height: 24 * Devices.density
                radius: Constants.radius
                color: "#88ffffff"
                opacity: ratio
                visible: downloadingProgressIndicator.running

                Rectangle {
                    id: downloadProgressBar
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    width: parent.width * downloadProgress
                    color: "#88ffffff"
                    radius: Constants.radius
                }

                RowLayout {
                    id: downloadingProgressRow
                    anchors.centerIn: parent
                    spacing: 2 * Devices.density

                    BusyIndicator {
                        id: downloadingProgressIndicator
                        scale: 0.6
                    }

                    Label {
                        id: downloadProgressLabel
                        font.pixelSize: 8 * Devices.fontDensity
                        text: "Downloading"
                        color: "#000"
                    }
                }
            }

            Label {
                id: viewsLabel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: profileLabel.bottom
                anchors.topMargin: 2 * Devices.density
                font.pixelSize: 9 * Devices.fontDensity
                color: Material.background
                text: "500 views in last week"
                visible: !downloadingProgressIndicator.running
                opacity: ratio
            }
        }

        Label {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: Devices.statusBarHeight
            width: 40 * Devices.density
            height: Devices.standardTitleBarHeight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "#fff"
            font.pixelSize: 16 * Devices.fontDensity
            font.family: MaterialIcons.family
            text: MaterialIcons.mdi_dots_vertical

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
}
