import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Layouts 1.3
import globals 1.0
import components 1.0
import models 1.0
import requests 1.0
import queries 1.0

Item {
    id: dis
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property real menuWidth: 200

    property alias listView: listView
    property alias headerItem: headerItem
    property alias closeBtn: closeBtn
    property alias confirmBtn: confirmBtn

    property variant selectMode
    property Viewport mainViewport: Viewport.viewport

    property string premiumMsg

    signal clicked(int index)
    signal pressAndHold(int index, variant pos, int side)
    signal addListRequest()
    signal premiumBuyRequest()

    Rectangle {
        anchors.fill: parent
        color: selectMode? Colors.background : Colors.deepBackground
        opacity: selectMode? 0.5 : 1
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
        clip: true

        topMargin: 4 * Devices.density
        bottomMargin: 4 * Devices.density + (selectMode? confirmBtn.height : 0)

        header: Item {
            width: listView.width
            height: headerRow.height + 30 * Devices.density

            ColumnLayout {
                id: headerRow
                y: 15 * Devices.density
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 10 * Devices.density

                MButton {
                    id: addBtn
                    Layout.preferredWidth: headerRow.width * 0.5
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: 9 * Devices.fontDensity
                    text: qsTr("Add List") + Translations.refresher
                    highlighted: true
                    visible: Subscription.listsLimits > listView.count-1 || premiumMsg.length == 0

                    Connections {
                        target: addBtn
                        onClicked: dis.addListRequest()
                    }
                }
            }
        }

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

                    Rectangle {
                        anchors.fill: parent
                        color: Colors.foreground
                        opacity: 0.1
                        visible: itemDel.pressed
                    }
                }

                MouseArea {
                    id: itemDel
                    anchors.fill: parent
                    pressAndHoldInterval: 400

                    PointMapListener {
                        id: listener
                        source: itemDel
                        dest: mainViewport
                        x: itemDel.width/2
                        y: itemDel.height/2
                    }

                    Connections {
                        target: itemDel
                        onPressAndHold: dis.pressAndHold(model.index, listener.result, 0)
                        onClicked: {
                            if (selectMode)
                                checkBox.toggle()
                            else
                                dis.clicked(model.index)
                        }
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
                            text: model.referenceId? MaterialIcons.mdi_earth : MaterialIcons[model.icon]
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0 * Devices.density

                        MLabel {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            font.pixelSize: 9 * Devices.fontDensity
                            text: model.title
                        }

                        MLabel {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            font.pixelSize: 8 * Devices.fontDensity
                            opacity: 0.8
                            text: model.subtitle
                            visible: text.length > 0
                        }
                    }

                    MLabel {
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_earth
                        color: model.listColor == "transparent"? Colors.foreground : model.listColor
                        visible: model.publicList
                    }

                    MButton {
                        id: menuBtn
                        Layout.preferredWidth: 30 * Devices.density
                        font.family: MaterialIcons.family
                        font.pixelSize: 12 * Devices.fontDensity
                        text: MaterialIcons.mdi_dots_horizontal
                        visible: !selectMode && model.listId > UserActions.TypeItemListsStart
                        flat: true
                        opacity: 0.6

                        Connections {
                            onClicked: dis.pressAndHold(model.index, Qt.point((dis.LayoutMirroring.enabled? menuBtn.x + menuBtn.width + menuWidth/2 : menuBtn.x - menuWidth/2) + listener.result.x - itemDel.width/2, listener.result.y),
                                                        (dis.LayoutMirroring.enabled? -1 : 1))
                        }
                    }

                    MCheckBox {
                        id: checkBox
                        visible: selectMode? true : false
                        checked: model.checked
                        onCheckedChanged: model.checked = checked
                    }
                }
            }
        }
    }

    MButton {
        id: confirmBtn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20 * Devices.density
        anchors.rightMargin: 20 * Devices.density
        anchors.bottomMargin: Devices.navigationBarHeight + 20 * Devices.density
        font.pixelSize: 9 * Devices.fontDensity
        text: qsTr("Done") + Translations.refresher
        highlighted: true
        visible: selectMode? true : false
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Lists") + Translations.refresher
        color: selectMode? "transparent" : Colors.headerColor
        shadow: selectMode? false : Devices.isAndroid
        light: (!selectMode || Colors.darkMode) && !Colors.lightHeader

        HeaderBackButton {
            id: closeBtn
            iosPopup: true
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
