import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    property bool refreshing: false

    data: [
        {
            "background": false,
            "color": "transparent",
            "modelData": [
            ],
            "section": "Recents\\More\\float:/recents",
            "type": "recents"
        },
        {
            "background": false,
            "color": "transparent",
            "modelData": [
            ],
            "section": "Shelf\\Edit\\edit",
            "type": "favorites"
        },
    ]
}
