import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Models 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0
import models 1.0

DrawerFrame {
    id: dis
    width: Constants.width
    height: Constants.height
    property alias poetsList: poetsList
    property alias selectedList: selectedList
    property alias offlineSearchSwitch: offlineSearchSwitch
    headerLabel.text: qsTr("Search Filter") + Translations.refresher

    flickable.interactive: false

    readonly property real itemsHeight: 50 * Devices.density

    ColumnLayout {
        anchors.fill: parent
        spacing: 4 * Devices.density

        RowLayout {
            Layout.leftMargin: 8 * Devices.density
            Layout.rightMargin: 8 * Devices.density

            Label {
                Layout.fillWidth: true
                font.pixelSize: 9 * Devices.fontDensity
                font.bold: true
                horizontalAlignment: Text.AlignLeft
                text: qsTr("Search only in offline poets") + Translations.refresher
            }

            Switch {
                id: offlineSearchSwitch
                checked: false
            }
        }

        AsemanListView {
            id: poetsList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: 40
            delegate: SearchFilterItem {
                id: poetItem
                width: poetsList.width
                height: itemsHeight
                addMode: true
                poetName: model.title

                Connections {
                    target: poetItem
                    onClicked: {
                        selectedList.model.append(poetsList.model.get(
                                                      model.index))
                        Tools.jsDelayCall(100, selectedList.positionViewAtEnd)
                    }
                }
            }

            ReloadItem {
                anchors.centerIn: parent
                viewItem: poetsList
                z: -1
            }

            HScrollBar {
                color: Colors.primary
                scrollArea: poetsList
                anchors.top: poetsList.top
                anchors.bottom: poetsList.bottom
                anchors.right: poetsList.right
            }
        }

        Label {
            Layout.fillWidth: true
            Layout.topMargin: 20 * Devices.density
            Layout.leftMargin: 8 * Devices.density
            Layout.rightMargin: 8 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            font.bold: true
            horizontalAlignment: Text.AlignLeft
            text: qsTr(
                      "Selected categories to search:") + Translations.refresher
            color: Colors.accent
        }

        AsemanListView {
            id: selectedList
            Layout.fillWidth: true
            Layout.minimumHeight: 50 * Devices.density
            Layout.preferredHeight: Math.min(count * itemsHeight,
                                             dis.height / 3)
            clip: true
            model: AsemanListModel {}
            delegate: SearchFilterItem {
                id: selectedItem
                width: poetsList.width
                height: itemsHeight
                addMode: false
                poetName: model.title

                Connections {
                    target: selectedItem
                    onClicked: selectedList.model.remove(model.index)
                }
            }

            HScrollBar {
                color: Colors.primary
                scrollArea: selectedList
                anchors.top: selectedList.top
                anchors.bottom: selectedList.bottom
                anchors.right: selectedList.right
            }
        }

        Button {
            Layout.fillWidth: true
            text: qsTr("Accept") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
            highlighted: true
            Layout.leftMargin: 8 * Devices.density
            Layout.rightMargin: 8 * Devices.density
            Layout.bottomMargin: 8 * Devices.density
        }
    }
}
