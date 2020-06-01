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

Item {
    id: searchForm
    width: Constants.width
    height: Constants.height
    clip: true

    property alias keywordField: keywordField
    property alias listView: listView
    property alias headerItem: headerItem
    property alias poetCombo: poetCombo
    property alias poetsBusyIndicator: poetsBusyIndicator
    property alias busyIndicator: busyIndicator
    property alias resultHeaderLabel: resultHeaderLabel

    signal clicked(string link, int index)

    Label {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 50 * Devices.density
        font.family: MaterialIcons.family
        font.pixelSize: 70 * Devices.fontDensity
        text: MaterialIcons.mdi_magnify
        opacity: 0.1
        visible: !busyIndicator.running && listView.count == 0
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
    }

    ColumnLayout {
        id: headerColumn
        parent: listView.headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 4 * Devices.density
        spacing: 14 * Devices.density

        Rectangle {
            Layout.fillWidth: true
            Layout.margins: 10 * Devices.density
            Layout.preferredHeight: 40 * Devices.density
            radius: Constants.radius
            color: Colors.lightBackground

            ComboBox {
                id: poetCombo
                anchors.fill: parent
                displayText: ""
                flat: true
                opacity: 0
            }

            RowLayout {
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20 * Devices.density
                spacing: 10 * Devices.density

                Label {
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 9 * Devices.fontDensity
                    color: Colors.accent
                    text: qsTr("Search domain:") + Translations.refresher
                }

                Label {
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 9 * Devices.fontDensity
                    text: poetCombo.currentText
                    Layout.fillWidth: true
                }

                BusyIndicator {
                    id: poetsBusyIndicator
                    scale: 0.6
                    Layout.preferredHeight: 28 * Devices.density
                    Layout.preferredWidth: 28 * Devices.density
                    Material.accent: Colors.foreground
                }
            }
        }

        Label {
            id: resultHeaderLabel
            Layout.fillWidth: true
            Layout.leftMargin: 10 * Devices.density
            Layout.rightMargin: 10 * Devices.density
            Layout.preferredHeight: 30 * Devices.density
            font.pixelSize: 10 * Devices.fontDensity
            horizontalAlignment: Text.AlignLeft
        }
    }

    AsemanListView {
        id: listView
        anchors.bottom: parent.bottom
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        header: Item {
            width: listView.width
            height: headerColumn.height
        }

        delegate: Rectangle {
            id: item
            width: listView.width
            height: column.height + 60 * Devices.density
            color: Colors.lightBackground

            ItemDelegate {
                id: itemDel
                anchors.fill: parent

                Connections {
                    target: itemDel
                    onClicked: searchForm.clicked(model.link, model.index)
                }
            }

            ColumnLayout {
                id: column
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20 * Devices.density
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: - itemFooter.height / 2
                spacing: 6 * Devices.density

                Repeater {
                    model: AsemanListModel { data: verses }

                    Label {
                        Layout.fillWidth: true
                        text: model.text
                        font.pixelSize: 10 * Devices.fontDensity
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        horizontalAlignment: model.position === PoemVersesModel.PositionRight? Text.AlignRight : (model.position === PoemVersesModel.PositionLeft? Text.AlignLeft
                                             : (model.position === PoemVersesModel.PositionCenteredVerse1 || model.position === PoemVersesModel.PositionCenteredVerse2? Text.AlignHCenter
                                             : Text.AlignRight))

                        LayoutMirroring.enabled: false
                        LayoutMirroring.childrenInherit: true
                    }
                }
            }

            Rectangle {
                id: itemFooter
                height: 20 * Devices.density
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: Qt.lighter(Colors.primary)

                RowLayout {
                    anchors.right: parent.right
                    anchors.margins: 10 * Devices.density
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4 * Devices.density

                    Label {
                        Layout.alignment: Qt.AlignLeft
                        text: model.poet.name
                        color: "#fff"
                        font.pixelSize: 8 * Devices.fontDensity
                    }

                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        font.family: MaterialIcons.family
                        text: LayoutMirroring.enabled? MaterialIcons.mdi_chevron_left : MaterialIcons.mdi_chevron_right
                        color: "#fff"
                        font.pixelSize: 12 * Devices.fontDensity
                    }

                    Repeater {
                        model: AsemanListModel { data: categories }

                        RowLayout {
                            spacing: 4 * Devices.density

                            Label {
                                Layout.alignment: Qt.AlignLeft
                                text: model.title
                                color: "#fff"
                                font.pixelSize: 8 * Devices.fontDensity
                            }

                            Label {
                                Layout.alignment: Qt.AlignVCenter
                                font.family: MaterialIcons.family
                                text: LayoutMirroring.enabled? MaterialIcons.mdi_chevron_left : MaterialIcons.mdi_chevron_right
                                color: "#fff"
                                font.pixelSize: 12 * Devices.fontDensity
                            }
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true
                        text: model.poem.title
                        color: "#fff"
                        font.pixelSize: 8 * Devices.fontDensity
                    }

                }
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        color: Colors.primary
        scrollArea: listView
    }

    Header {
        id: headerItem
        color: Colors.primary
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        shadow: Devices.isAndroid

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 10 * Devices.density
            anchors.leftMargin: 10 * Devices.density
            anchors.top: searchRow.top
            anchors.bottom: searchRow.bottom
            anchors.topMargin: 5 * Devices.density
            radius: Constants.radius
            color: "#000"
            opacity: 0.3
        }

        RowLayout {
            id: searchRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: Devices.statusBarHeight/2
            spacing: 10 * Devices.density
            anchors.rightMargin: 20 * Devices.density
            anchors.leftMargin: 20 * Devices.density

            Label {
                text: MaterialIcons.mdi_magnify
                font.family: MaterialIcons.family
                font.pixelSize: 16 * Devices.fontDensity
                color: "#fff"
            }

            TextField {
                id: keywordField
                bottomPadding: 8 * Devices.density
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                placeholderText: qsTr("Search") + Translations.refresher
                Material.theme: Material.Dark
                IOSStyle.theme: IOSStyle.Dark
                font.pixelSize: 9 * Devices.fontDensity
                background: Item {}
            }
        }

        RoundButton {
            anchors.right: parent.right
            anchors.rightMargin: 10 * Devices.density
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1 * Devices.density
            width: 40 * Devices.density
            height: width
            radius: width / 2
            flat: true
            font.family: MaterialIcons.family
            font.pixelSize: 16 * Devices.density
            text: MaterialIcons.mdi_close
            IOSStyle.foreground: "#fff"
            Material.foreground: "#fff"
            visible: keywordField.text.length
            onClicked: keywordField.text = ""
        }
    }
}
