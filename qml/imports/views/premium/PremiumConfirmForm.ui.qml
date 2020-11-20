import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import AsemanQml.Controls 2.0
import AsemanQml.Models 2.0
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
    property alias busyIndicator: busyIndicator
    property alias cancelBtn: cancelBtn
    property alias couponBtn: couponBtn
    property alias couponField: couponField
    property alias couponBusy: couponBusy
    property alias items: items

    property color packageColor: "#fff"

    property bool forceDark

    Rectangle {
        anchors.fill: parent
        color: forceDark? "#222" : Colors.background
        opacity: 0.5
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
        Material.accent: packageColor
        IOSStyle.foreground: packageColor
    }

    AsemanFlickable {
        id: flickable
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.bottom: couponLayout.top
        anchors.left: parent.left
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height
        clip: true
        visible: !busyIndicator.running

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
                        color: packageColor
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
                            color: packageColor
                        }
                    }
                }

                Repeater {
                    id: items

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
                            color: packageColor
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

    RowLayout {
        id: couponLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: intervalPayCombo.top
        anchors.leftMargin: 20 * Devices.density
        anchors.rightMargin: 20 * Devices.density
        visible: flickable.visible

        Material.accent: packageColor
        IOSStyle.accent: packageColor

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 48 * Devices.density

            TextField {
                id: couponField
                anchors.fill: parent
                horizontalAlignment: Text.AlignLeft
                placeholder: qsTr("Coupon") + Translations.refresher
                font.pixelSize: 10 * Devices.fontDensity
                selectByMouse: true
                enabled: !couponBusy.running
            }

            BusyIndicator {
                id: couponBusy
                anchors.centerIn: parent
                scale: 0.6
                running: true
                Material.accent: packageColor
                IOSStyle.foreground: packageColor
            }
        }

        Button {
            id: couponBtn
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Submit") + Translations.refresher
            highlighted: true
            flat: true
            enabled: couponField.length > 3 && !couponBusy.running
            Material.elevation: 0
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
        visible: flickable.visible
        model: [qsTr("Monthly"), qsTr("Yearly") + Translations.refresher]
        delegate: ItemDelegate {
            width: intervalPayCombo.width

            Label {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 9 * Devices.fontDensity
                text: model.text
            }
            IOSStyle.theme: AsemanGlobals.iosTheme
            Material.theme: AsemanGlobals.androidTheme
        }
    }

    Button {
        id: confirmBtn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20 * Devices.density
        font.pixelSize: 9 * Devices.fontDensity
        visible: flickable.visible
        text: qsTr("Confirm") + Translations.refresher
        highlighted: true
        Material.accent: packageColor
        IOSStyle.accent: packageColor
        Material.elevation: 0
    }

    Rectangle {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: Devices.standardTitleBarHeight
        color: packageColor

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
