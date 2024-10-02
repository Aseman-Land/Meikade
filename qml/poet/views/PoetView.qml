import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import globals 1.0
import components 1.0
import models 1.0

Item {
    id: myMeikade
    width: Constants.width
    height: Constants.height
    property alias menuBtn: menuBtn
    property alias settingsLabel: settingsLabel
    property alias viewsLabel: viewsLabel
    property alias bioTitle: bioTitle
    property alias bioBtn: bioBtn
    property alias poetBioScene: poetBioScene
    property alias gridView: gridView
    property alias coverImage: coverImage
    property alias avatarBtn: avatarBtn
    property alias avatar: avatar
    property alias profileLabel: profileLabel
    property alias settingsBtn: settingsBtn
    property alias progressBar: progressBar
    property bool readWriteMode: false

    property int viewCount

    readonly property real ratioAbs: Math.min(ratio, 1)
    readonly property real ratio: Math.max(
                                      0,
                                      coverImage.height + mapListener.result.y
                                      - Devices.standardTitleBarHeight - Devices.statusBarHeight)
                                  / (coverImage.height - Devices.standardTitleBarHeight
                                     - Devices.statusBarHeight)

    property alias downloadProgress: progressBar.progress

    signal addBookRequest()

    Rectangle {
        anchors.fill: parent
        color: Colors.deepBackground
    }

    PointMapListener {
        id: mapListener
        source: gridView.headerItem
        dest: myMeikade
    }

    ReloadItem {
        id: busyIndicator
        anchors.centerIn: parent
        viewItem: gridView
    }

    FlexiList {
        id: gridView
        anchors.fill: parent

        header: Item {
            width: gridView.width
            height: coverImage.height + 10 * Devices.density
        }

        footer: Item {
            width: gridView.width
            height: (readWriteMode? addColumn.height + 40 * Devices.density : poetBioBack.height) + 10 * Devices.density

            ColumnLayout {
                id: addColumn
                anchors.left: parent.left
                anchors.right: parent.right
                y: 20 * Devices.density
                visible: readWriteMode
                spacing: 4 * Devices.density

                MLabel {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    text: qsTr("To add new book please tap on the below button.") + Translations.refresher
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    opacity: 0.7
                }

                MButton {
                    Layout.alignment: Qt.AlignHCenter
                    highlighted: true
                    text: qsTr("New Book") + Translations.refresher
                    icon: MaterialIcons.mdi_plus
                    iconPixelSize: 12 * Devices.fontDensity

                    Connections {
                        onClicked: addBookRequest()
                    }
                }
            }
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
                         0)

        Rectangle {
            id: poetBioBack
            anchors.left: parent.left
            anchors.right: parent.right
            height: bioColumn.height + Devices.navigationBarHeight
            color: Colors.lightBackground
        }

        MItemDelegate {
            id: bioBtn
            anchors.fill: parent
            hoverEnabled: false
        }

        RowLayout {
            id: bioColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 14 * Devices.density
            anchors.rightMargin: 14 * Devices.density
            spacing: 0

            MLabel {
                id: bioTitle
                Layout.fillWidth: true
                Layout.preferredHeight: Devices.standardTitleBarHeight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12 * Devices.fontDensity
                horizontalAlignment: Text.AlignLeft
                text: qsTr("Biography") + Translations.refresher
            }

            MLabel {
                font.family: MaterialIcons.family
                font.pixelSize: 16 * Devices.fontDensity
                text: MaterialIcons.mdi_chevron_up
                opacity: 0.4
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
            height: 210 * Devices.density
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

            Item {
                height: Devices.standardTitleBarHeight
                width: height
                x: ratioAbs * (coverImage.width/2 - width/2) + (1 - ratioAbs) * (LayoutMirroring.enabled? parent.width - width - Devices.standardTitleBarHeight + 10 * Devices.density : Devices.standardTitleBarHeight - 10 * Devices.density)
                y: ratioAbs * (parent.height/2 - height + 10 * Devices.density)
                scale: (34 + 16 * ratioAbs) / 50

                RoundedItem {
                    anchors.centerIn: parent
                    width: 100 * Devices.density
                    height: 100 * Devices.density
                    scale: 0.5
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    radius: Constants.radius * 2
                    visible: !AsemanGlobals.testPoetImagesDisable

                    Rectangle {
                        anchors.fill: parent
                        color: Colors.background
                        visible: avatar.status != Image.Ready
                    }

                    MLabel {
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
                        ignoreSslErrors: AsemanGlobals.ignoreSslErrors
                    }

                    MItemDelegate {
                        id: avatarBtn
                        anchors.fill: parent
                    }
                }
            }

            MLabel {
                id: profileLabel
                font.pixelSize: 14 * Devices.fontDensity
                scale: (10 + 4 * ratio) / 14
                color: "#fff"
                text: "Bardia Daneshvar"
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 30 * Devices.density * ratioAbs
            }

            MinimalProgressBar {
                id: progressBar
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: profileLabel.bottom
                anchors.topMargin: 8 * Devices.density
                height: 24 * Devices.density
                opacity: ratio
            }

            MLabel {
                id: viewsLabel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: profileLabel.bottom
                anchors.topMargin: 2 * Devices.density
                font.pixelSize: 9 * Devices.fontDensity
                color: "#fff"
                text: viewCount + " " + qsTr("Views")
                visible: !progressBar.running && viewCount
                opacity: ratio
            }
        }

        MLabel {
            id: settingsLabel
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

            MItemDelegate {
                id: settingsBtn
                anchors.fill: parent
                z: -1
            }
        }

        HeaderBackButton {
            id: menuBtn
            color: "#fff"
            x: LayoutMirroring.enabled? parent.width - width : 0
        }
    }
}
