import QtQuick 2.12
import globals 1.0
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import "flexi"

AsemanListView {
    id: list
    anchors.leftMargin: spacing
    anchors.rightMargin: spacing
    spacing: 10 * Devices.density
    topMargin: spacing
    bottomMargin: spacing

    signal linkRequest(string link)

    delegate: FlexiRowItem {
        id: rowItem
        width: list.width
        type: model.type
        modelData: model.modelData
        listView: list

        Connections {
            target: rowItem
            onClicked: list.linkRequest(link)
        }

        Rectangle {
            width: list.width + list.spacing * 2
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: -list.spacing / 2
            anchors.horizontalCenter: parent.horizontalCenter
            color: model.color
            z: -1
        }

        Rectangle {
            width: list.width + list.spacing * 2
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: -list.spacing / 2
            anchors.horizontalCenter: parent.horizontalCenter
            visible: model.background
            color: Colors.darkMode? "#000" : "#fff"
            z: -1
        }
    }

    section.criteria: ViewSection.FullString
    section.property: "section"

    section.delegate: Item {
        id: sectionItem
        width: list.width
        height: text.length ? 40 * Devices.density : 0

        property string text: {
            var idx = section.indexOf(":")
            if (idx >= 0)
                return section.slice(0, idx)
            else
                return section
        }
        property string link: {
            var idx = section.indexOf(":")
            if (idx >= 0)
                return section.slice(idx+1)
            else
                return ""
        }

        Label {
            id: sectionTxt
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: list.spacing
            font.pixelSize: 10 * Devices.fontDensity
            text: sectionItem.text

            Button {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: sectionItem.link.length
                text: qsTr("More") + Translations.refresher
                flat: true
                width: 50 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                onClicked: list.linkRequest(sectionItem.link)
            }
        }
    }
}
