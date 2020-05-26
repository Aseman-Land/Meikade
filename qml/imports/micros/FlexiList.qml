import QtQuick 2.12
import globals 1.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
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

    signal linkRequest(string link, variant properties)
    signal moreRequest()

    delegate: FlexiRowItem {
        id: rowItem
        width: list.width
        type: model.type
        modelData: model.modelData
        listView: list
        onClicked: list.linkRequest(link, properties)
        onMoreRequest: if (model.index === list.count-1) list.moreRequest()

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

        property string fulltext: section
        property string text: {
            var idx = section.indexOf("\\")
            if (idx >= 0)
                return section.slice(0, idx)
            else
                return section
        }
        property string link: {
            var idx = section.indexOf("\\")
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
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 10 * Devices.fontDensity
            text: {
                switch (sectionItem.text) {
                case "Recents":
                    return qsTr("Recents") + Translations.refresher;
                case "Meikade Online":
                    return qsTr("Explore") + Translations.refresher;
                case "Offlines":
                    return qsTr("Offlines") + Translations.refresher;
                case "Favorites":
                    return qsTr("Favorites") + Translations.refresher;
                default:
                    return sectionItem.text;
                }
            }

            Button {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: sectionItem.link.length
                text: {
                    var idx = sectionItem.link.indexOf("\\");
                    var linkLabel = (idx<0? sectionItem.link : sectionItem.link.slice(0, idx));
                    switch (linkLabel) {
                    case "Manage":
                        return qsTr("Manage") + Translations.refresher
                    case "More":
                    default:
                        return qsTr("More") + Translations.refresher
                    }
                }
                highlighted: true
                flat: true
                width: 60 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                onClicked: list.linkRequest(sectionItem.link.slice(sectionItem.link.indexOf("\\") + 1), {"fulltext": sectionItem.fulltext})
            }
        }
    }
}
