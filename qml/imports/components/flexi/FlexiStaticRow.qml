import QtQuick 2.12
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import globals 1.0
import AsemanQml.Models 2.0
import "delegates"

FlexiAbstractRow {
    id: homeRow
    width: Constants.width
    height: rowItem.height

    property alias model: model

    Row {
        id: rowItem
        anchors.centerIn: parent
        spacing: 10 * Devices.density
        Repeater {
            id: rptr
            model: FlexiSwitableModel {
                id: model
            }
            delegate: Delegate {
                id: itemDel
                width: height
                height: 100 * Devices.density
                title: model.title + (isVerse? " - " + model.details.first_verse : "")
                isVerse: model.details && model.details.first_verse? true : false
                subtitle: model.subtitle
                color: model.color == undefined? "#88000000" : model.color.length? model.color : Colors.lightBackground
                image: AsemanGlobals.testPoetImagesDisable? "" : model.image
                type: model.type
                link: model.link
                moreHint: model.moreHint? model.moreHint : false

                Connections {
                    target: itemDel
                    onClicked: homeRow.clicked(itemDel.link, rptr.model.get(index))
                    onMoreRequest: homeRow.moreRequest()
                }
            }
        }
    }
}
