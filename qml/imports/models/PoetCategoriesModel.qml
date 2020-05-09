import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Models 2.0

AsemanListModel {
    data: [
        {
            "title": qsTr("Classic") + Translations.refresher,
            "id": 1
        },
        {
            "title": qsTr("New Age") + Translations.refresher,
            "id": 2
        }
    ]
}
