import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Layouts 1.3
import globals 1.0
import components 1.0
import models 1.0

Item {
    id: dis
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias listView: listView
    property alias headerItem: headerItem
    property alias closeBtn: closeBtn
    property alias backBtn: backBtn

    property alias title: headerItem.title

    signal clicked(int index)

    Rectangle {
        anchors.fill: parent
        color: Colors.deepBackground
    }

    ReloadItem {
        id: busyIndicator
        anchors.centerIn: parent
        viewItem: listView
    }

    MLabel {
        anchors.centerIn: parent
        font.pixelSize: 8 * Devices.fontDensity
        text: qsTr("There is no item here") + Translations.refresher
        visible: listView.count == 0 && !busyIndicator.running
        opacity: 0.6
    }

    AsemanListView {
        id: listView
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        topMargin: 4 * Devices.density
        bottomMargin: 4 * Devices.density

        delegate: Item {
            id: itemObj
            width: listView.width
            height: rowLayout.height + 20 * Devices.density

            RoundedItem {
                anchors.fill: parent
                anchors.leftMargin: 8 * Devices.density
                anchors.rightMargin: 8 * Devices.density
                anchors.topMargin: 4 * Devices.density
                anchors.bottomMargin: 4 * Devices.density
                radius: Constants.radius / 2

                Rectangle {
                    anchors.fill: parent
                    color: Colors.background
                }

                MItemDelegate {
                    id: itemDel
                    anchors.fill: parent

                    Connections {
                        target: itemDel
                        onClicked: dis.clicked(model.index)
                    }
                }

                RowLayout {
                    id: rowLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10 * Devices.density
                    spacing: 10 * Devices.density

                    Item {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.preferredHeight: 38 * Devices.density
                        Layout.preferredWidth: 38 * Devices.density

                        Rectangle {
                            anchors.fill: parent
                            anchors.centerIn: parent
                            radius: Constants.radius
                            opacity: 0.2
                            color: Colors.foreground
                        }

                        MLabel {
                            anchors.centerIn: parent
                            font.family: MaterialIcons.family
                            font.pixelSize: 14 * Devices.fontDensity
                            text: MaterialIcons.mdi_heart
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2 * Devices.density

                        MLabel {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            font.pixelSize: 9 * Devices.fontDensity
                            text: model.title + " - " + model.verseText
                        }

                        MLabel {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            font.pixelSize: 8 * Devices.fontDensity
                            opacity: 0.8
                            text: model.value
                        }
                    }

                    MLabel {
                        font.family: MaterialIcons.family
                        font.pixelSize: 16 * Devices.fontDensity
                        text: LayoutMirroring.enabled? MaterialIcons.mdi_chevron_left : MaterialIcons.mdi_chevron_right
                        opacity: 0.4
                    }
                }
            }
        }
    }

    MHeader {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        title: qsTr("Notes") + Translations.refresher

        HeaderBackButton {
            id: closeBtn
            y: 0
            iosPopup: true
        }

        HeaderMenuButton {
            id: backBtn
            ratio: 1
            y: 0
            buttonColor: Colors.headerTextColor
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listView.bottom
        anchors.top: listView.top
        color: Colors.primary
        scrollArea: listView
    }
}
