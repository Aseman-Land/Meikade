import QtQuick 2.12
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import globals 1.0
import models 1.0
import "delegates"

FlexiDynamicRow {
    property alias count: recentsModel.count

    list.model: OfflinePoetsModel {
        id: recentsModel
    }
}
