import QtQuick 2.12
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import globals 1.0
import "delegates"

FlexiAbstractRow {
    id: hflexible
    width: Constants.width
    height: columnItem.height

    property alias model: model
    property alias list: list

    PointMapListener {
        id: mapListener
        source: columnItem
        dest: listView
    }

    Column {
        id: columnItem
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10 * Devices.density

        Repeater {
            id: list
            model: FlexiSwitableModel {
                id: model
            }
            delegate: Loader {
                width: columnItem.width
                height: 100 * Devices.density * model.heightRatio
                active: 0 < globalY + height && globalY < listView.height

                property real globalY: mapListener.result.y + (model.index * (height + columnItem.spacing))

                sourceComponent: Delegate {
                    id: itemDel
                    anchors.fill: parent
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
                        onClicked: hflexible.clicked(itemDel.link, list.model.get(index))
                        onMoreRequest: hflexible.moreRequest()
                    }
                }
            }
        }
    }
}
