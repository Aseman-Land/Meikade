import QtQuick 2.12
import design 1.0
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

    AsemanListView {
        id: list
        anchors.fill: parent
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
            width: list.width
            type: model.type
            modelData: model.modelData

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
        section.delegate: Item {
            width: list.width
            height: sectionTxt.text.length ? 40 * Devices.density : 0

            Label {
                id: sectionTxt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: list.spacing
                font.pixelSize: 10 * Devices.fontDensity
                text: section
            }
        }
    }

    ScrollBar {
        anchors.right: parent.right
        anchors.bottom: list.bottom
        anchors.top: list.top
        color: Material.primary
        scrollArea: list
    }
}
