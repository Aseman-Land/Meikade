import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import micros 1.0

Page {
    id: homeForm
    width: Constants.width
    height: Constants.height

    property alias gridView: gridView

    readonly property real headerHeight: 200 * Devices.density
    readonly property real ratio: 1 - Math.min( Math.max(-headerListener.result.y / gridView.headerItem.height, 0), 1)

    PointMapListener {
        id: headerListener
        source: gridView.headerItem
        dest: homeForm
    }

    AsemanGridView {
        id: gridView
        anchors.fill: parent
        model: 50
        cellWidth: homeForm.width / Math.floor(homeForm.width / 160)
        cellHeight: cellWidth
        bottomMargin: Devices.standardTitleBarHeight
        header: Item {
            width: gridView.width
            height: headerHeight
        }

        delegate: Item {
            width: gridView.cellWidth
            height: gridView.cellHeight

            Label {
                anchors.centerIn: parent
                text: model.index
            }
        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Devices.standardTitleBarHeight + Devices.statusBarHeight + (headerHeight - Devices.standardTitleBarHeight + Devices.statusBarHeight) * ratio
        gradient: Gradient {
            GradientStop { position: 0.6; color: Colors.background }
            GradientStop { position: 1.0; color: "transparent" }
        }

        Item {
            anchors.fill: parent
            anchors.topMargin: Devices.statusBarHeight

            ColumnLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: ratio * 10 +  2 * Devices.density

                Label {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    font.pixelSize: 10 * Devices.fontDensity
                    text: qsTr("Setup Favorites") + Translations.refresher
                    scale: ratio * 0.8 + 1
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 9 * Devices.fontDensity
                    text: qsTr("Please choose at lease 5 your favorites.") + Translations.refresher
                    scale: ratio*0.2 + 1
                    opacity: 0.8
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: Devices.standardTitleBarHeight + Devices.statusBarHeight
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: Colors.background }
        }
    }
}
