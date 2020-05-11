import QtQuick 2.12
import QtQuick.Controls 2.0
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
        model: AsemanListModel {
            id: model
        }
        spacing: 10 * Devices.density
        delegate: Delegate {
            id: itemDel
            width: 180 * Devices.density
            height: list.height
            title: model.title
            color: model.color.length? model.color : Colors.lightBackground
            subtitle: model.subtitle
            image: model.image
            type: model.type
            link: model.link

            Connections {
                target: itemDel
                onClicked: homeRow.clicked(itemDel.link, list.model.get(index))
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
