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
    property alias menuBtn: menuBtn
    property alias headerItem: headerItem
    property alias logoutBtn: logoutBtn
    property alias languageCombo: languageCombo
    property alias themeCombo: themeCombo

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
                            Material.theme: AsemanGlobals.androidTheme
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
                        model: Devices.isAndroid? [qsTr("Light") + Translations.refresher, qsTr("Dark")] :
                                                  [qsTr("Auto") + Translations.refresher, qsTr("Light"), qsTr("Dark")]
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
                            Material.theme: AsemanGlobals.androidTheme
                        }
                    }
                }
            }
        }
    }

    Button {
        id: logoutBtn
        anchors.right: flick.right
        anchors.left: flick.left
        anchors.bottom: flick.bottom
        anchors.bottomMargin: 10 * Devices.density
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
