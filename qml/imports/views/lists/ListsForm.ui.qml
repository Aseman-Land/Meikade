import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0
import models 1.0
import requests 1.0
import queries 1.0

Item {
    id: dis
    width: Constants.width
    height: Constants.height

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

    Label {
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

                RoundButton {
                    id: addBtn
                    Layout.preferredWidth: headerRow.width * 0.5
                    Layout.alignment: Qt.AlignHCenter
                    font.pixelSize: 9 * Devices.fontDensity
                    text: qsTr("Add List") + Translations.refresher
                    highlighted: true
                    visible: Subscription.listsLimits > listView.count || premiumMsg.length == 0

                    Connections {
                        target: addBtn
                        onClicked: dis.addListRequest()
                    }
                }

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    opacity: 0.8
                    text: premiumMsg
                    visible: premiumMsg.length
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: Subscription.listsLimits > listView.count? Colors.foreground : "#a00"
                }

                Label {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * Devices.density
                    Layout.rightMargin: 20 * Devices.density
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 8 * Devices.fontDensity
                    text: qsTr("To buy premium account click on below button") + Translations.refresher
                    visible: !addBtn.visible && premiumMsg.length && !AsemanGlobals.disablePremiumListsWarn && Bootstrap.payment
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    visible: !addBtn.visible && premiumMsg.length && !AsemanGlobals.disablePremiumListsWarn && Bootstrap.payment
                    spacing: 0

                    RoundButton {
                        id: premiumBtn
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: listView.width * 0.5
                        text: qsTr("Premium Account") + Translations.refresher
                        font.pixelSize: 9 * Devices.fontDensity
                        highlighted: true
                        Material.accent: Subscription.premiumColor
                        IOSStyle.accent: Subscription.premiumColor
                        Material.elevation: 0

                        Connections {
                            target: premiumBtn
                            onClicked: dis.premiumBuyRequest()
                        }
                    }

                    RoundButton {
                        id: premiumDisMisBtn
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Don't show this message again") + Translations.refresher
                        font.underline: true
                        font.pixelSize: 8 * Devices.fontDensity
                        flat: true
                        highlighted: true

                        Connections {
                            target: premiumDisMisBtn
                            onClicked: AsemanGlobals.disablePremiumListsWarn = true
                        }
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

                        Label {
                            anchors.centerIn: parent
                            font.family: MaterialIcons.family
                            font.pixelSize: 14 * Devices.fontDensity
                            text: MaterialIcons[model.icon]
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2 * Devices.density

                        Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            elide: Text.ElideRight
                            maximumLineCount: 1
                            font.pixelSize: 9 * Devices.fontDensity
                            text: model.title
                        }

                        Label {
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

                    Button {
                        id: menuBtn
                        Layout.preferredWidth: 30 * Devices.density
                        font.family: MaterialIcons.family
                        font.pixelSize: 12 * Devices.fontDensity
                        text: MaterialIcons.mdi_dots_horizontal
                        visible: !selectMode && model.listId > UserActions.TypeItemListsStart
                        flat: true
                        opacity: 0.6

                        Connections {
                            onClicked: dis.pressAndHold(model.index, Qt.point((dis.LayoutMirroring.enabled? menuBtn.x + menuBtn.width + menuWidth/2 : menuBtn.x - menuWidth/2), listener.result.y),
                                                        (dis.LayoutMirroring.enabled? -1 : 1))
                        }
                    }

                    CheckBox {
                        id: checkBox
                        visible: selectMode? true : false
                        checked: model.checked
                        onCheckedChanged: model.checked = checked
                    }
                }
            }
        }
    }

    Button {
        id: confirmBtn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20 * Devices.density
        anchors.rightMargin: 20 * Devices.density
        anchors.bottomMargin: Devices.navigationBarHeight
        font.pixelSize: 9 * Devices.fontDensity
        text: qsTr("Done") + Translations.refresher
        highlighted: true
        Material.accent: Colors.primary
        IOSStyle.accent: Colors.primary
        visible: selectMode? true : false
        Material.elevation: 0
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Lists") + Translations.refresher
        color: selectMode? "transparent" : Colors.header
        shadow: selectMode? false : Devices.isAndroid
        light: !selectMode || Colors.darkMode

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
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.accent: Qt.darker(Colors.primary, 1.3)
                Material.accent: Qt.darker(Colors.primary, 1.3)
                Material.theme: Material.Dark
                Material.elevation: 0
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
}
