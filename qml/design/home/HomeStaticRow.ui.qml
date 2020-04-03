import QtQuick 2.12
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import design 1.0
import "delegates"

HomeAbstractRow {
    width: Constants.width
    height: 100 * Devices.density

    property alias model: model

    Row {
        id: row
        height: parent.height
        anchors.centerIn: parent
        spacing: 10 * Devices.density
        Repeater {
            model: AsemanListModel {
                id: model
            }
            delegate: Delegate {
                width: height
                height: row.height
                title: model.title
                description: model.description
                color: model.color
                image: model.image
                type: model.type
            }
        }
    }
}
