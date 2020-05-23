import QtQuick 2.12
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import globals 1.0
import models 1.0
import "delegates"

FlexiDynamicRow {

    property alias type: recentsModel.type

    Label {
        anchors.centerIn: parent
        font.pixelSize: 8 * Devices.fontDensity
        text: qsTr("There is no recent item") + Translations.refresher
        visible: recentsModel.count == 0
        opacity: 0.6
    }

    list.model: RecentsModel {
        id: recentsModel
    }
}
