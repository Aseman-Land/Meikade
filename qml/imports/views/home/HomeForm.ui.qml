import QtQuick 2.12
import globals 1.0
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0

Item {
    id: homeForm
    width: Constants.width
    height: Constants.height

    property alias list: list
    property alias headerItem: headerItem

    signal linkRequest(string link)

    AsemanListView {
        id: list
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: spacing
        anchors.rightMargin: spacing
        spacing: 10 * Devices.density
        topMargin: spacing
        bottomMargin: spacing
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

        delegate: HomeRowItem {
            id: rowItem
            width: list.width
            type: model.type
            modelData: model.modelData

            Connections {
                target: rowItem
                onClicked: homeForm.linkRequest(link)
            }

            Rectangle {
                width: homeForm.width
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: -list.spacing / 2
                anchors.horizontalCenter: parent.horizontalCenter
                color: model.color
                z: -1
            }

            Rectangle {
                width: homeForm.width
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: -list.spacing / 2
                anchors.horizontalCenter: parent.horizontalCenter
                visible: model.background
                color: Material.theme == Material.Dark ? "#000" : "#fff"
                z: -1
            }
        }

        section.criteria: ViewSection.FullString
        section.property: "section"
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
    }
}
