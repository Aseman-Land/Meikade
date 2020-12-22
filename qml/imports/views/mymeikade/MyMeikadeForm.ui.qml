import QtQuick 2.12
import globals 1.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import requests 1.0

Rectangle {
    id: myMeikade
    width: Constants.width
    height: Constants.height
    color: Colors.deepBackground

    property alias gridView: gridView
    property alias coverImage: coverImage
    property alias avatarBtn: avatarBtn
    property alias avatar: avatar
    property alias profileLabel: profileLabel
    property alias settingsBtn: settingsBtn
    property alias profileColumn: profileColumn
    property alias dailyDiary: dailyDiary
    property alias weeklyDiary: weeklyDiary
    property alias favesDiary: favesDiary
    property alias authBtn: authBtn

    property bool signedIn

    readonly property real ratio: 1 + mapListener.result.y / coverImage.height
    readonly property real ratioAbs: Math.max(0, ratio)

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

        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: true

        bottomMargin: 200 * Devices.density

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
                    color: Colors.lightBackground
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 0

                    Label {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.bottomMargin: 8 * Devices.density
                        font.pixelSize: 18 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons[model.icon]
                    }

                    Label {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.pixelSize: 9 * Devices.fontDensity
                        text: model.title
                    }

                    Label {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.pixelSize: 7 * Devices.fontDensity
                        visible: model.underco
                        color: "#a00"
                        text: qsTr("Available Soon") + Translations.refresher
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
        height: Math.max(mapListener.result.y + coverImage.height, Devices.standardTitleBarHeight + Devices.statusBarHeight)
        clip: true

        Image {
            id: coverImage
            y: Math.min(0, Math.max(mapListener.result.y / 2, (Devices.standardTitleBarHeight + Devices.statusBarHeight - height)/2))
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.min(width * 9 / 16, myMeikade.height/3)
            sourceSize.width: width * 1.2
            sourceSize.height: height * 1.2
            fillMode: Image.PreserveAspectCrop
            source: AsemanGlobals.testHeaderImagesDisable? "" : "../images/cover.jpg"

            Rectangle {
                anchors.fill: parent
                color: "#000"
                opacity: (1 - ratioAbs) * 0.3
            }

            ItemDelegate {
                id: authBtn
                anchors.fill: parent
                scale: Math.min(0.6 + ratioAbs*0.4, 1)
                opacity: ratioAbs * 2 - 1
                visible: opacity > 0 && !signedIn
                enabled: Bootstrap.initialized

                Label {
                    id: loginLabel
                    anchors.centerIn: parent
                    font.pixelSize: 10 * Devices.fontDensity
                    color: "#fff"
                    text: Bootstrap.initialized? qsTr("Login / Register") + Translations.refresher : qsTr("Meikade")

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -8 * Devices.density
                        radius: Constants.radius
                        color: "#222"
                        z: -1
                        opacity: 0.6
                    }
                }
            }

            ColumnLayout {
                id: profileColumn
                anchors.centerIn: parent
                spacing: 20 * Devices.density
                scale: Math.min(0.6 + ratioAbs*0.4, 1)
                opacity: ratioAbs * 2 - 1
                visible: opacity > 0 && signedIn

                Rectangle {
                    Layout.preferredWidth: 92 * Devices.density
                    Layout.preferredHeight: 92 * Devices.density
                    radius: height / 2
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    color: "#fff"
                    visible: false

                    RoundedItem {
                        anchors.fill: parent
                        anchors.margins: 3 * Devices.density
                        radius: height / 2

                        Label {
                            anchors.centerIn: parent
                            color: Colors.primary
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
                    }
                }

                Label {
                    id: profileLabel
                    font.pixelSize: 9 * Devices.fontDensity
                    Layout.alignment: Qt.AlignHCenter
                    color: "#fff"
                    text: "Bardia Daneshvar"

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -8 * Devices.density
                        radius: Constants.radius
                        color: "#222"
                        z: -1
                        opacity: 0.6

                        ItemDelegate {
                            id: avatarBtn
                            anchors.fill: parent
                        }
                    }
                }
            }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                spacing: 0
                opacity: ratioAbs * 2 - 1
                visible: opacity > 0

                DiaryItem {
                    id: dailyDiary
                    width: parent.width/3
                    unitLabel.text: qsTr("Daily Reads") + Translations.refresher

                }
                DiaryItem {
                    id: weeklyDiary
                    width: parent.width/3
                    unitLabel.text: qsTr("Hours per Week") + Translations.refresher
                }
                DiaryItem {
                    id: favesDiary
                    width: parent.width/3
                    unitLabel.text: qsTr("Favoriteds Poets") + Translations.refresher
                }
            }
        }

        Label {
            y: Devices.statusBarHeight
            height: Devices.standardTitleBarHeight
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 10 * Devices.fontDensity
            text: signedIn? profileLabel.text : qsTr("My Meikade") + Translations.refresher
            color: "#fff"
            opacity: 1 - ratioAbs * 1.5
        }

        ItemDelegate {
            id: settingsBtn
            y: Devices.statusBarHeight
            anchors.left: parent.left
            height: Devices.standardTitleBarHeight
            width: height
            visible: false

            Label {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -3 * Devices.density
                color: "#fff"
                font.pixelSize: 16 * Devices.fontDensity
                font.family: MaterialIcons.family
                text: MaterialIcons.mdi_settings
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: gridView.bottom
        anchors.top: gridView.top
        anchors.topMargin: coverImage.height
        anchors.bottomMargin: 58 * Devices.density + Devices.navigationBarHeight
        color: Colors.primary
        scrollArea: gridView
    }
}
