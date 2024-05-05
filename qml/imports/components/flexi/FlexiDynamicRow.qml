import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import globals 1.0
import "delegates"

FlexiAbstractRow {
    id: homeRow
    width: Constants.width
    height: 100 * Devices.density

    property alias model: model
    property alias list: list

    AsemanListView {
        id: list
        anchors.fill: parent
        orientation: ListView.Horizontal
        model: FlexiSwitableModel {
            id: model
        }
        spacing: 10 * Devices.density
        delegate: Delegate {
            id: itemDel
            width: 180 * Devices.density
            height: list.height
            title: model.title + (isVerse? " - " + model.details.first_verse : "")
            isVerse: model.details && model.details.first_verse? true : false
            color: model.color && model.color.length? model.color : Colors.lightBackground
            subtitle: model.subtitle
            image: AsemanGlobals.testPoetImagesDisable? "" : model.image
            type: model.type
            link: model.link
            moreHint: model.moreHint? model.moreHint : false

            Connections {
                target: itemDel
                onClicked: {
                    var properties = list.model.get(index);
                    homeRow.clicked(itemDel.link, properties)
                }
//                onClicked: homeRow.clicked(itemDel.link, {})
                onMoreRequest: homeRow.moreRequest()
            }
        }
    }
}
