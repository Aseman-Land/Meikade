import QtQuick 2.12
import MeikadeDesign 1.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0

Rectangle {
    id: myMeikade
    width: Constants.width
    height: Constants.height
    color: Constants.background
    property alias gridView: gridView
    property alias coverImage: coverImage
    property alias avatarBtn: avatarBtn
    property alias avatar: avatar
    property alias profileLabel: profileLabel
    property alias settingsBtn: settingsBtn

    signal clicked(string link)

    PointMapListener {
        id: mapListener
        source: gridView.headerItem
        dest: myMeikade
    }

    AsemanGridView {
        id: gridView
        anchors.fill: parent
        anchors.leftMargin: 10 * Devices.density
        anchors.rightMargin: 10 * Devices.density
        cellWidth: gridView.width / Math.floor(
                       gridView.width / (160 * Devices.density))
        cellHeight: 108 * Devices.density
        model: 5

        header: Item {
            width: gridView.width
            height: coverImage.height + 10 * Devices.density
        }

        delegate: Item {
            width: gridView.cellWidth
            height: gridView.cellHeight

            RoundedItem {
                anchors.fill: parent
                anchors.margins: 4 * Devices.density
                radius: Constants.radius

                Rectangle {
                    anchors.fill: parent
                    color: Qt.lighter(Material.background, 1.3)
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4 * Devices.density

                    Label {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.pixelSize: 28 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons[model.icon]
                    }

                    Label {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.pixelSize: 9 * Devices.fontDensity
                        text: model.title
                    }
                }

                ItemDelegate {
                    id: idel
                    anchors.fill: parent
                    hoverEnabled: false

                    Connections {
                        target: idel
                        onClicked: myMeikade.clicked(model.link)
                    }
                }
            }
        }
    }

    Item {
        id: coverScene
        anchors.left: parent.left
        anchors.right: parent.right
        height: mapListener.result.y + coverImage.height
        clip: true

        Image {
            id: coverImage
            anchors.left: parent.left
            anchors.right: parent.right
            height: width * 9 / 16
            sourceSize.width: width * 1.2
            sourceSize.height: height * 1.2
            fillMode: Image.PreserveAspectCrop
            source: "../images/cover.jpg"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20 * Devices.density

                Rectangle {
                    Layout.preferredWidth: 92 * Devices.density
                    Layout.preferredHeight: 92 * Devices.density
                    radius: height / 2
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    color: Material.background

                    RoundedItem {
                        anchors.fill: parent
                        anchors.margins: 3 * Devices.density
                        radius: height / 2

                        Label {
                            anchors.centerIn: parent
                            color: Material.primary
                            font.pixelSize: 32 * Devices.fontDensity
                            font.family: MaterialIcons.family
                            text: MaterialIcons.mdi_account
                        }

                        Image {
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
                    font.pixelSize: 9 * Devices.fontDensity
                    color: Material.background
                    text: "Bardia Daneshvar"

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -8 * Devices.density
                        radius: Constants.radius
                        color: Material.foreground
                        z: -1
                        opacity: 0.6
                    }
                }
            }
        }

        Label {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 8 * Devices.density + Devices.statusBarHeight
            anchors.leftMargin: 8 * Devices.density
            color: "#fff"
            font.pixelSize: 16 * Devices.fontDensity
            font.family: MaterialIcons.family
            text: MaterialIcons.mdi_settings

            ItemDelegate {
                id: settingsBtn
                anchors.fill: parent
                anchors.margins: -8 * Devices.density
                z: -1
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: gridView.bottom
        anchors.top: gridView.top
        color: Material.primary
        scrollArea: gridView
    }
}
