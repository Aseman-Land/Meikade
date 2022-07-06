import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import requests 1.0
import globals 1.0
import components 1.0
import models 1.0
import "privates"

Item {
    id: dis
    width: Constants.width
    height: Constants.height
    property alias menuBtn: menuBtn
    property alias headerItem: headerItem
    property alias logoutBtn: logoutBtn
    property alias loginBtn: loginBtn
    property alias languageCombo: languageCombo
    property alias themeCombo: themeCombo
    property alias phraseSwitch: phraseSwitch
    property alias mixedHeaderSwitch: mixedHeaderSwitch
    property alias phraseNumberSwitch: phraseNumberSwitch
    property alias fontSizeSlider: fontSizeSlider
    property alias accountStateLabel: accountStateLabel
    property alias accountDaysLabel: accountDaysLabel
    property alias accountPremiumBuy: accountPremiumBuy

    Material.theme: Material.Dark
    IOSStyle.theme: IOSStyle.Dark

    Rectangle {
        anchors.fill: parent
        color: "#222"
    }

    AsemanFlickable {
        id: flick
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        flickableDirection: Flickable.VerticalFlick

        Item {
            id: scene
            width: flick.width
            height: Math.max(sceneColumn.height + 20 * Devices.density,
                             flick.height)

            ColumnLayout {
                id: sceneColumn
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 10 * Devices.density
                anchors.margins: 20 * Devices.density
                spacing: 4 * Devices.density

                RowLayout {
                    visible: Bootstrap.initialized && AsemanGlobals.accessToken.length && activeSubscription && !Bootstrap.fullyUnlocked && Bootstrap.subscription && Bootstrap.payment && Bootstrap.trusted
                    Layout.topMargin: 10 * Devices.density
                    Layout.bottomMargin: 30 * Devices.density

                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Account State") + Translations.refresher
                    }

                    Label {
                        id: accountStateLabel
                        Layout.minimumWidth: 80 * Devices.density
                        font.pixelSize: 9 * Devices.fontDensity
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        color: Subscription.packageColor

                        Label {
                            id: accountDaysLabel
                            anchors.top: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 7 * Devices.fontDensity
                            horizontalAlignment: Text.AlignLeft
                            color: Subscription.packageColor
                            visible: Subscription.premium
                        }

                        Button {
                            id: accountPremiumBuy
                            anchors.top: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 100 * Devices.density
                            height: 36 * Devices.density
                            font.pixelSize: 8 * Devices.fontDensity
                            text: qsTr("Upgrade") + Translations.refresher
                            highlighted: true
                            Material.accent: Subscription.premiumColor
                            IOSStyle.accent: Subscription.premiumColor
                            visible: !Subscription.premium
                        }
                    }
                }

                RowLayout {
                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Language") + Translations.refresher
                    }

                    ComboBox {
                        id: languageCombo
                        Layout.preferredWidth: 180 * Devices.density
                        font.pixelSize: 9 * Devices.fontDensity
                        textRole: "title"
                        model: GTranslations.model
                        delegate: ItemDelegate {
                            width: languageCombo.width

                            Label {
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 9 * Devices.fontDensity
                                text: model.title
                            }
                            IOSStyle.theme: AsemanGlobals.iosTheme
                            Material.theme: AsemanGlobals.androidEffectiveTheme
                        }
                    }
                }

                RowLayout {
                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Theme") + Translations.refresher
                    }

                    ComboBox {
                        id: themeCombo
                        Layout.preferredWidth: 100 * Devices.density
                        font.pixelSize: 9 * Devices.fontDensity
                        model: [qsTr("Auto") + Translations.refresher, qsTr("Light"), qsTr("Dark")]
                        delegate: ItemDelegate {
                            width: themeCombo.width

                            Label {
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 9 * Devices.fontDensity
                                text: modelData
                            }
                            IOSStyle.theme: AsemanGlobals.iosTheme
                            Material.theme: AsemanGlobals.androidEffectiveTheme
                        }
                    }
                }

                RowLayout {
                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Mixed Header") + Translations.refresher
                    }

                    Switch {
                        id: mixedHeaderSwitch
                    }
                }


                RowLayout {
                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Show Phrase") + Translations.refresher
                    }

                    Switch {
                        id: phraseSwitch
                    }
                }


                RowLayout {
                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Show Phrase Number") + Translations.refresher
                    }

                    Switch {
                        id: phraseNumberSwitch
                    }
                }


                RowLayout {
                    Layout.topMargin: 20 * Devices.density
                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Poems font size") + Translations.refresher
                    }
                }

                RowLayout {
                    spacing: 0

                    Label {
                        Layout.preferredWidth: dis.width / 4
                        font.pixelSize: 8 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Small") + Translations.refresher
                    }
                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 10 * Devices.fontDensity
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("Medium") + Translations.refresher
                    }
                    Label {
                        Layout.preferredWidth: dis.width / 4
                        font.pixelSize: 12 * Devices.fontDensity
                        horizontalAlignment: Text.AlignRight
                        text: qsTr("Large") + Translations.refresher
                    }
                }

                Slider {
                    id: fontSizeSlider
                    Layout.fillWidth: true
                    Layout.topMargin: -6 * Devices.density
                    snapMode: Slider.SnapOnRelease
                    orientation: Qt.Horizontal
                    from: 1
                    to: 5
                    stepSize: 1
                }

            }
        }
    }

    Button {
        id: loginBtn
        anchors.right: flick.right
        anchors.left: flick.left
        anchors.bottom: flick.bottom
        anchors.bottomMargin: 10 * Devices.density + Devices.navigationBarHeight
        anchors.margins: 20 * Devices.density
        highlighted: true
        font.pixelSize: 9 * Devices.fontDensity
        text: qsTr("Login") + Translations.refresher
        visible: AsemanGlobals.accessToken.length == 0 && Bootstrap.initialized
    }

    Button {
        id: logoutBtn
        anchors.right: flick.right
        anchors.left: flick.left
        anchors.bottom: flick.bottom
        anchors.bottomMargin: 10 * Devices.density + Devices.navigationBarHeight
        anchors.margins: 20 * Devices.density
        highlighted: true
        font.pixelSize: 9 * Devices.fontDensity
        text: qsTr("Logout") + Translations.refresher
        IOSStyle.accent: "#700"
        Material.accent: "#700"
        visible: AsemanGlobals.accessToken.length
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Settings") + Translations.refresher
        color: "#333"
        shadow: Devices.isAndroid

        HeaderMenuButton {
            id: menuBtn
            ratio: 1
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: flick.bottom
        anchors.top: flick.top
        color: "#fff"
        scrollArea: flick
    }
}

