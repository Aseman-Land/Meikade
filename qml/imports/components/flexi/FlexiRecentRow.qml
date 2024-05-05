import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import globals 1.0
import models 1.0
import "delegates"

FlexiDynamicRow {
    height: list.visible? 100 * Devices.density : 0

    property alias type: recentsModel.type
    property alias count: recentsModel.count

    list.visible: recentsModel.count > 0
    list.model: RecentsModel {
        id: recentsModel
    }
}
