import QtQuick 2.12
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import MeikadeDesign 1.0
import "delegates"

HomeAbstractRow {
    id: hflexible
    width: Constants.width
    height: 100 * Devices.density

    property alias model: model
    readonly property real itemsWidth: (hflexible.width - row.spacing * (hflexible.model.count - 1)) / model.count

    Row {
        id: row
        anchors.fill: parent
        spacing: 10 * Devices.density
        Repeater {
            model: AsemanListModel {
                id: model
            }
            delegate: Delegate {
                id: itemDel
                width: itemsWidth
                height: row.height
                title: model.title
                description: model.description
                color: model.color
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
