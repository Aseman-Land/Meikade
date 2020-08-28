import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Models 2.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: model

    UserActions {
        id: userActions

        property variant items: new Array

        Component.onCompleted: Tools.jsDelayCall(10, refresh)
    }

    Connections {
        target: GlobalSignals
        onListsRefreshed: refresh()
    }

    property int poetId
    property int catId
    property int poemId
    property int verseId
    function refresh() {
        var lists = userActions.select("", "type > :type AND declined = 0 AND poetId = 0 AND catId = 0 AND poemId = 0 AND verseId = 0",
                                       "ORDER BY value", {type: UserActions.TypeItemListsStart})

        model.clear();
        model.append({
            "title": qsTr("Favorites"),
            "subtitle": "",
            "icon": "mdi_heart",
            "link": "float:/favorites",
            "listId": UserActions.TypeFavorite
        })

        lists.forEach(function(l){
            var extra = Tools.jsonToVariant(l.extra)
            model.append({
                "title": l.value,
                "subtitle": "",
                "icon": "mdi_library",
                "link": "float:/favorites?listId=" + l.type,
                "listId": l.type
            })
        })
    }
}
