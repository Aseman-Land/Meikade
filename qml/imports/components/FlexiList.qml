import QtQuick 2.12
import globals 1.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
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

    delegate: Column {
        width: list.width

        Item {
            id: sectionItem
            width: parent.width
            height: text.length ? 2 * sectionTxt.height : 0
            visible: rowItem.count

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

            MLabel {
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
                    case "Shelf":
                        return qsTr("Shelf") + Translations.refresher;
                    default:
                        return sectionItem.text;
                    }
                }

                MLabel {
                    anchors.rightMargin: 10 * Devices.density
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    visible: sectionItem.link.length
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 8 * Devices.fontDensity
                    color: Colors.accent
                    text: {
                        if (rowItem.editMode)
                            return qsTr("Finish") + Translations.refresher

                        var idx = sectionItem.link.indexOf("\\");
                        var linkLabel = (idx<0? sectionItem.link : sectionItem.link.slice(0, idx));
                        switch (linkLabel) {
                        case "Manage":
                            return qsTr("Manage") + Translations.refresher
                        case "Edit":
                            return qsTr("Edit") + Translations.refresher
                        case "More":
                        default:
                            return qsTr("More") + Translations.refresher
                        }
                    }

                    ItemDelegate {
                        anchors.fill: parent
                        anchors.margins: -10 * Devices.density
                        onClicked: {
                            var link = sectionItem.link.slice(sectionItem.link.indexOf("\\") + 1);
                            switch (link) {
                            case "edit":
                                rowItem.editMode = !rowItem.editMode;
                                break;

                            default:
                                list.linkRequest(link, {"fulltext": sectionItem.fulltext});
                                break;
                            }

                        }
                    }

                }
            }
        }

        FlexiRowItem {
            id: rowItem
            width: parent.width
            type: model.type
            heightRatio: model.heightRatio == undefined || !model.heightRatio? 1 : model.heightRatio
            dataList: model.dataList
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

    }
}
