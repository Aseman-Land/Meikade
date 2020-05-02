import QtQuick 2.12
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import globals 1.0
import AsemanQml.Models 2.0
import "delegates"

FlexiAbstractRow {
    id: homeRow
    width: Constants.width
    height: row.height

    property alias model: model

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10 * Devices.density
        Repeater {
            model: AsemanListModel {
                id: model
            }
            delegate: Delegate {
                id: itemDel
                width: height
                height: 100 * Devices.density
                title: model.title
                subtitle: model.subtitle
                color: model.color.length? model.color : Colors.lightBackground
                image: model.image
                type: model.type
                link: model.link

                Connections {
                    target: itemDel
                    onClicked: homeRow.clicked(itemDel.link)
                }
            }
        }
    }
}
