import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Models 2.0
import queries 1.0

AsemanListModel {
    data: [
        {
            "title": qsTr("Favorites") + Translations.refresher,
            "subtitle": qsTr("%1 items").arg(userActions.items.length),
            "icon": "mdi_heart",
            "link": "float:/favorites"
        }
    ]

    UserActions {
        id: userActions

        property variant items: new Array

        function refresh() {
            items = getItems(UserActions.TypeFavorite, 0, 200);
        }

        Component.onCompleted: Tools.jsDelayCall(10, refresh)
    }
}
