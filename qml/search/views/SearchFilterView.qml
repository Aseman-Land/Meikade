import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Models 2.0
import QtQuick.Layouts 1.3
import globals 1.0
import components 1.0
import models 1.0
import "privates"

DrawerFrame {
    id: dis
    width: Constants.width
    height: Constants.height
    headerLabel.text: qsTr("Search Filter") + Translations.refresher
    flickable.interactive: false

    property alias poetsList: poetsList
    property alias selectedList: selectedList
    property alias selectedListModel: selectedListModel
    property alias onlineSearchSwitch: onlineSearchSwitch
    property alias accurateSearchSwitch: accurateSearchSwitch
    property alias accurateSearchHelpBtn: accurateSearchHelpBtn
    property alias acceptBtn: acceptBtn

    readonly property real itemsHeight: 50 * Devices.density

    ColumnLayout {
        anchors.fill: parent
        spacing: 4 * Devices.density

        RowLayout {
            Layout.leftMargin: 8 * Devices.density
            Layout.rightMargin: 8 * Devices.density

            MLabel {
                Layout.fillWidth: true
                font.pixelSize: 9 * Devices.fontDensity
                font.bold: true
                horizontalAlignment: Text.AlignLeft
                text: qsTr("Online Search") + Translations.refresher
            }

            MSwitch {
                id: onlineSearchSwitch
                checked: true
            }
        }

        RowLayout {
            Layout.leftMargin: 8 * Devices.density
            Layout.rightMargin: 8 * Devices.density
            Layout.topMargin: -10 * Devices.density

            MLabel {
                font.pixelSize: 9 * Devices.fontDensity
                font.bold: true
                horizontalAlignment: Text.AlignLeft
                text: qsTr("Accurate word search") + Translations.refresher
            }

            MButton {
                id: accurateSearchHelpBtn
                Layout.preferredHeight: 40 * Devices.density
                Layout.preferredWidth: 120 * Devices.density
                flat: true
                font.pixelSize: 9 * Devices.fontDensity
                highlighted: true
                text: qsTr("(Read More)") + Translations.refresher
            }

            Item {
                Layout.preferredHeight: 1
                Layout.fillWidth: true
            }

            MSwitch {
                id: accurateSearchSwitch
                checked: true
                enabled: onlineSearchSwitch.checked
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
                        for (var i=0; i<selectedList.model.count; i++)
                            if (selectedList.model.get(i).id == model.id)
                                return;

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

        MLabel {
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
            model: AsemanListModel { id: selectedListModel }
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

            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: 4 * Devices.density
                anchors.rightMargin: 4 * Devices.density
                z: -1
                color: "#22ffffff"
                radius: 10 * Devices.density
            }

            HScrollBar {
                color: Colors.primary
                scrollArea: selectedList
                anchors.top: selectedList.top
                anchors.bottom: selectedList.bottom
                anchors.right: selectedList.right
            }
        }

        MButton {
            id: acceptBtn
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

