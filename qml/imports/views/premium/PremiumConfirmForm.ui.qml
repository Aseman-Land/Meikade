import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import AsemanQml.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import requests 1.0
import globals 1.0
import micros 1.0

Item {
    width: Constants.width
    height: Constants.height

    IOSStyle.theme: forceDark? IOSStyle.Dark : AsemanGlobals.iosTheme
    Material.theme: forceDark? Material.Dark : AsemanGlobals.androidTheme

    property alias titleLabel: titleLabel
    property alias subtitleLabel: subtitleLabel
    property alias confirmBtn: confirmBtn
    property alias intervalPayCombo: intervalPayCombo
    property alias cancelBtn: cancelBtn

    property bool forceDark

    Rectangle {
        anchors.fill: parent
        color: forceDark? "#222" : Colors.background
        opacity: 0.5
    }

    AsemanFlickable {
        id: flickable
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.bottom: intervalPayCombo.top
        anchors.left: parent.left
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height
        clip: true

        EscapeItem {
            id: scene
            width: flickable.width
            height: Math.max(flickable.height, sceneColumn.height)

            ColumnLayout {
                id: sceneColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 15 * Devices.density
                spacing: 10 * Devices.density


                RowLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    Layout.bottomMargin: 20 * Devices.density
                    spacing: 10 * Devices.density

                    Label {
                        Layout.alignment: Qt.AlignBottom
                        font.pixelSize: 40 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_podium_gold
                        color: Subscription.premiumColor
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignBottom
                        Layout.fillWidth: true
                        spacing: 4 * Devices.density

                        Label {
                            id: titleLabel
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 11 * Devices.fontDensity
                            text: "50,000 IRR per Month"
                        }

                        Label {
                            id: subtitleLabel
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 11 * Devices.fontDensity
                            text: "400,000 IRR per Year"
                            color: Subscription.premiumColor
                        }
                    }
                }

                Repeater {
                    model: ListModel {
                        ListElement {
                            title: qsTr("Unlimited Notes")
                        }
                        ListElement {
                            title: qsTr("Unlimited Lists")
                        }
                        ListElement {
                            title: qsTr("Unlimited Offline Poems")
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: 20 * Devices.density
                        Layout.rightMargin: 20 * Devices.density
                        spacing: 20 * Devices.density

                        Label {
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 14 * Devices.fontDensity
                            font.family: MaterialIcons.family
                            text: MaterialIcons.mdi_check
                            color: Subscription.premiumColor
                        }

                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 9 * Devices.fontDensity
                            text: model.title
                        }
                    }
                }
            }
        }
    }

    ComboBox {
        id: intervalPayCombo
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: confirmBtn.top
        anchors.leftMargin: 20 * Devices.density
        anchors.rightMargin: 20 * Devices.density
        font.pixelSize: 9 * Devices.fontDensity
        model: [qsTr("Monthly"), qsTr("Yearly") + Translations.refresher]
    }

    Button {
        id: confirmBtn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20 * Devices.density
        font.pixelSize: 9 * Devices.fontDensity
        enabled: nameField.isValid
        text: qsTr("Confirm") + Translations.refresher
        highlighted: true
        Material.accent: Subscription.premiumColor
        IOSStyle.accent: Subscription.premiumColor
        Material.elevation: 0
    }

    Rectangle {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: Devices.standardTitleBarHeight
        color: Subscription.premiumColor

        Separator {}

        Label {
            id: headerLabel
            anchors.centerIn: parent
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Premium Account") + Translations.refresher
            color: "#fff"
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: cancelBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Cancel") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                Material.accent: Qt.darker(headerItem.color, 1.3)
                Material.theme: Material.Dark
                IOSStyle.accent: Qt.darker(headerItem.color, 1.3)
                IOSStyle.theme: IOSStyle.Dark
                Material.elevation: 0
            }
        }
    }
}
