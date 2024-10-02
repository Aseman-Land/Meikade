import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
import QtQuick.Layouts 1.3
import requests 1.0
import globals 1.0
import components 1.0
import models 1.0
import "privates"

MPage {
    id: dis
    width: Constants.width
    height: Constants.height
    Style.backgroundColor: Colors.background

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

    AsemanFlickable {
        id: flick
        anchors.fill: parent
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
                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Language") + Translations.refresher
                    }

                    MComboBox {
                        id: languageCombo
                        Layout.preferredWidth: 180 * Devices.density
                        textRole: "title"
                        model: GTranslations.model
                    }
                }

                RowLayout {
                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Theme") + Translations.refresher
                    }

                    MComboBox {
                        id: themeCombo
                        Layout.preferredWidth: 100 * Devices.density
                        model: [qsTr("Auto") + Translations.refresher, qsTr("Light"), qsTr("Dark")]
                    }
                }

                RowLayout {
                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Mixed Header") + Translations.refresher
                    }

                    MSwitch {
                        id: mixedHeaderSwitch
                    }
                }


                RowLayout {
                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Show Phrase") + Translations.refresher
                    }

                    MSwitch {
                        id: phraseSwitch
                    }
                }


                RowLayout {
                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Show Phrase Number") + Translations.refresher
                    }

                    MSwitch {
                        id: phraseNumberSwitch
                    }
                }


                RowLayout {
                    Layout.topMargin: 20 * Devices.density
                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Poems font size") + Translations.refresher
                    }
                }

                RowLayout {
                    spacing: 0

                    MLabel {
                        Layout.preferredWidth: dis.width / 4
                        font.pixelSize: 8 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Small") + Translations.refresher
                    }
                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 10 * Devices.fontDensity
                        horizontalAlignment: Text.AlignHCenter
                        text: qsTr("Medium") + Translations.refresher
                    }
                    MLabel {
                        Layout.preferredWidth: dis.width / 4
                        font.pixelSize: 12 * Devices.fontDensity
                        horizontalAlignment: Text.AlignRight
                        text: qsTr("Large") + Translations.refresher
                    }
                }

                MSlider {
                    id: fontSizeSlider
                    Layout.fillWidth: true
                    Layout.topMargin: -6 * Devices.density
                    from: 1
                    to: 5
                    orientation: Qt.Horizontal
                    stepSize: 1
                }
            }
        }
    }

    MButton {
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

    MButton {
        id: logoutBtn
        anchors.right: flick.right
        anchors.left: flick.left
        anchors.bottom: flick.bottom
        anchors.bottomMargin: 10 * Devices.density + Devices.navigationBarHeight
        anchors.margins: 20 * Devices.density
        highlighted: true
        font.pixelSize: 9 * Devices.fontDensity
        text: qsTr("Logout") + Translations.refresher
        visible: AsemanGlobals.accessToken.length
    }

    header: MHeader {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        title: qsTr("Settings") + Translations.refresher

        HeaderBackButton {
            id: menuBtn
            color: Colors.headerTextColor
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

