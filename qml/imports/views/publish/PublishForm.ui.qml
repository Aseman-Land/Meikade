import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import globals 1.0

Page {
    id: form
    width: Constants.width
    height: Constants.height

    property alias scene: scene
    property alias busyIndicator: busyIndicator
    property alias closeBtn: closeBtn
    property real initedNum: 0
    property real agreementNum: 0

    Rectangle {
        anchors.fill: parent
        color: Colors.background
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        color: Colors.deepBackground

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 30 * Devices.density

                Item {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 8 * Devices.density
                    height: 4 * Devices.density

                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: Colors.foreground
                        opacity: 0.2
                    }

                    Rectangle {
                        height: parent.height
                        anchors.left: parent.left
                        width: parent.width * 0.33
                        radius: height / 2
                        color: Colors.accent
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.leftMargin: 8 * Devices.density
                Layout.rightMargin: 8 * Devices.density
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 10 * Devices.fontDensity
                text: qsTr("Review") + Translations.refresher
            }

            Item {
                id: scene
                Layout.topMargin: 13 * Devices.density
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                Rectangle {
                    id: agreementScene
                    anchors.left: parent.left
                    anchors.right: parent.right
                    y: parent.height * (1 - agreementNum)
                    height: parent.height * 0.6
                    anchors.margins: 8 * Devices.density
                    radius: 6 * Devices.density
                    color: Colors.lightBackground
                }
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        anchors.centerIn: parent
        running: false
    }

    Header {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        color: Colors.headerColor
        light: !Colors.lightHeader
        shadow: Devices.isAndroid

        Image {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: Devices.statusBarHeight/2
            width: 160 * Devices.density
            height: 160 * Devices.density
            scale: 0.3 + 0.5 * (1 - initedNum)
            source: Colors.lightHeader? "../explore/icons/meikade.png" : "../explore/icons/meikade-abstract.png"
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
        }

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14 * Devices.density
            anchors.rightMargin: 2 * Devices.density
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: closeBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Close") + Translations.refresher
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.foreground: Colors.foreground
                IOSStyle.background: Colors.deepBackground
                Material.foreground: Colors.foreground
                Material.background: Colors.deepBackground
                Material.theme: Material.Dark
                Material.elevation: 0
            }
        }
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height * (1 - initedNum) + 0 * initedNum
        clip: true

        Rectangle {
            width: form.height * 1.5
            height: width
            anchors.centerIn: parent
            rotation: 45
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.darker(Colors.primary, 2) }
                GradientStop { position: 1.0; color: Colors.primary }
            }
        }

        ColumnLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            y: Math.max(parent.height, headerItem.height)/2 - height/2 * (1 - initedNum) - (mkd_logo.height/2 + Devices.statusBarHeight/2) * initedNum
            spacing: 4 * Devices.density

            Image {
                id: mkd_logo
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 160 * Devices.density
                Layout.preferredHeight: 160 * Devices.density
                scale: 0.3 + 0.5 * (1 - initedNum)
                source: "../explore/icons/meikade-abstract.png"
                sourceSize.width: 200 * Devices.density
                sourceSize.height: 200 * Devices.density
                fillMode: Image.PreserveAspectFit
            }

            BusyIndicator {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: isAndroidStyle? 36 * Devices.density : 24 * Devices.density
                Layout.preferredHeight: isAndroidStyle? 36 * Devices.density : 24 * Devices.density
                IOSStyle.foreground: "#fff"
                Material.accent: "#fff"
                opacity: 1 - initedNum
                running: opacity > 0
            }

            Label {
                Layout.topMargin: 14 * Devices.density
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Please Wait...") + Translations.refresher
                font.pixelSize: 9 * Devices.fontDensity
                color: "#fff"
                opacity: 1 - initedNum
            }
        }
    }
}
