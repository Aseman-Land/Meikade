import QtQuick 2.12
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import globals 1.0
import "delegates"

FlexiAbstractRow {
    id: hflexible
    width: Constants.width
    height: row.height

    property alias model: model
    readonly property real itemsWidth: (hflexible.width - row.spacing * (hflexible.model.count - 1)) / model.count

    Row {
        id: row
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10 * Devices.density
        Repeater {
            model: AsemanListModel {
                id: model
            }
            delegate: Delegate {
                id: itemDel
                width: itemsWidth
                height: 100 * Devices.density * model.heightRatio
                title: model.title
                subtitle: model.subtitle
                color: model.color.length? model.color : Colors.lightBackground
                image: model.image
                type: model.type
                link: model.link

                Connections {
                    target: itemDel
                    onClicked: hflexible.clicked(itemDel.link)
                }
            }
        }
    }
}
