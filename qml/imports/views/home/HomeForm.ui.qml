import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import micros 1.0

Item {
    id: homeForm
    width: Constants.width
    height: Constants.height

    property alias list: list
    property alias headerItem: headerItem

    FlexiList {
        id: list
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
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

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: list.bottom
        anchors.top: list.top
        color: Colors.primary
        scrollArea: list
    }

    Header {
        id: headerItem
        color: Colors.primary
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Meikade") + Translations.refresher
        anchors.top: parent.top
        titleFontSize: 10 * Devices.fontDensity
    }
}
