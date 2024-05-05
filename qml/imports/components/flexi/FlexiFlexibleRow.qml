import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import globals 1.0
import "delegates"

FlexiAbstractRow {
    id: hflexible
    width: Constants.width
    height: rowItem.height

    property alias model: model
    readonly property real itemsWidth: (hflexible.width - rowItem.spacing * (hflexible.model.count - 1)) / model.count

    Row {
        id: rowItem
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10 * Devices.density
        Repeater {
            id: rptr
            model: FlexiSwitableModel {
                id: model
            }
            delegate: Delegate {
                id: itemDel
                width: itemsWidth
                height: 100 * Devices.density * model.heightRatio
                title: model.title + (isVerse? " - " + model.details.first_verse : "")
                isVerse: model.details && model.details.first_verse? true : false
                subtitle: model.subtitle
                color: model.color.length? model.color : Colors.lightBackground
                image: AsemanGlobals.testPoetImagesDisable? "" : model.image
                type: model.type
                link: model.link
                moreHint: model.moreHint? model.moreHint : false

                Connections {
                    target: itemDel
                    onClicked: hflexible.clicked(itemDel.link, rptr.model.get(index))
                    onMoreRequest: hflexible.moreRequest()
                }
            }
        }
    }
}
