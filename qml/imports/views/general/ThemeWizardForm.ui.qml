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

Item {
    id: dis
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias headerItem: headerItem
    property alias listView: listView
    property alias closeBtn: closeBtn
    property alias applyBtn: applyBtn

    Rectangle {
        anchors.fill: parent
        color: Colors.background
        opacity: 0.5
    }

    ColumnLayout {
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        spacing: 0

        Label {
            Layout.fillWidth: true
            Layout.topMargin: 8 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Please select theme") + Translations.refresher
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            Layout.fillWidth: true
            Layout.topMargin: 8 * Devices.density
            Layout.preferredHeight: 12 * Devices.density
            clip: true

            Rectangle {
                width: 15 * Devices.density
                height: width
                rotation: 45
                color: Colors.accent
                anchors.verticalCenter: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: ListView.Horizontal

            LayoutMirroring.enabled: false
            LayoutMirroring.childrenInherit: true

            model: ListModel {
                ListElement {
                    image: "themes/auto.png"
                    configTheme: 0
                    configColorToolbar: false
                }
                ListElement {
                    image: "themes/light-light.png"
                    configTheme: 1
                    configColorToolbar: false
                }
                ListElement {
                    image: "themes/light-color.png"
                    configTheme: 1
                    configColorToolbar: true
                }
                ListElement {
                    image: "themes/dark-color.png"
                    configTheme: 2
                    configColorToolbar: true
                }
            }
            leftMargin: (width - listView.height * 0.6)/2
            rightMargin: leftMargin
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 250
            snapMode: ListView.SnapOneItem
            preferredHighlightBegin: leftMargin
            preferredHighlightEnd: width - rightMargin
            delegate: Item {
                width: height * 0.6
                height: listView.height

                Image {
                    anchors.fill: parent
                    anchors.topMargin: 20 * Devices.density
                    anchors.bottomMargin: 20 * Devices.density
                    source: model.image
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: width * 1.2
                    sourceSize.height: height * 1.2
                    asynchronous: true
                }
            }
        }

        Button {
            id: applyBtn
            Layout.fillWidth: true
            Layout.bottomMargin: 8 * Devices.density
            Layout.leftMargin: 60 * Devices.density
            Layout.rightMargin: 60 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Apply and Close") + Translations.refresher
            highlighted: true
            Material.accent: Colors.accent
            IOSStyle.accent: Colors.accent
        }
    }

    Rectangle {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: Devices.standardTitleBarHeight
        color: "transparent"

        Separator {}

        Label {
            id: headerLabel
            anchors.centerIn: parent
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Theme Wizard") + Translations.refresher
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: closeBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Close") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                Material.accent: Qt.darker(Colors.primary, 1.3)
                Material.theme: Material.Dark
                IOSStyle.accent: Qt.darker(Colors.primary, 1.3)
                IOSStyle.theme: IOSStyle.Dark
                Material.elevation: 0
            }
        }
    }
}
