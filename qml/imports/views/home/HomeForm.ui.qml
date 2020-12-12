import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import globals 1.0
import micros 1.0

Item {
    id: homeForm
    width: Constants.width
    height: Constants.height

    property alias list: list
    property alias headerItem: headerItem

    Rectangle {
        id: listScene
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: Colors.deepBackground

        Rectangle {
            width: headerItem.width
            height: headerItem.height
            color: headerItem.color
        }

        ReloadItem {
            id: busyIndicator
            anchors.centerIn: parent
            viewItem: list
        }

        FlexiList {
            id: list
            topMargin: headerItem.height + spacing
            bottomMargin: 70 * Devices.density + Devices.navigationBarHeight
            anchors.fill: parent
            model: ListModel {
                ListElement {
                    type: "recents"
                    section: "Recents"
                }
                ListElement {
                    type: "static"
                    section: ""
                }
            }
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: listScene.bottom
        anchors.top: headerItem.bottom
        anchors.bottomMargin: 58 * Devices.density + Devices.navigationBarHeight
        color: Colors.primary
        scrollArea: list
    }

    Item {
        anchors.fill: headerItem
        clip: true

        FastBlur {
            width: listScene.width
            height: listScene.height
            source: listScene
            radius: Devices.isIOS? 64 : 0
            cached: true
            visible: Devices.isIOS
        }
    }

    Header {
        id: headerItem
        color: Colors.primary
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Meikade") + Translations.refresher
        anchors.top: parent.top
        titleFontSize: 10 * Devices.fontDensity
        shadow: Devices.isAndroid
        opacity: Devices.isIOS? 0.8 : 1
    }
}
