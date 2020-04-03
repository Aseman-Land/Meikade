import QtQuick 2.12
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import design 1.0
import "delegates"

HomeAbstractRow {
    width: Constants.width
    height: 100 * Devices.density

    property alias model: model

    AsemanListView {
        id: listv
        anchors.fill: parent
        orientation: ListView.Horizontal
        model: AsemanListModel {
            id: model
        }
        spacing: 10 * Devices.density
        delegate: Delegate {
            width: 180 * Devices.density
            height: listv.height
            title: model.title
            color: model.color
            description: model.description
            image: model.image
            type: model.type
        }
    }
}
