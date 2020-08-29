import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Models 2.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: model

    property variant selecteds: new Array

    UserActions {
        id: userActions

        property variant items: new Array

        Component.onCompleted: Tools.jsDelayCall(10, refresh)
    }

    Connections {
        target: GlobalSignals
        onListsRefreshed: refresh()
    }

    function refresh() {
        var lists = userActions.select("", "type > :type AND declined = 0 AND poetId = 0 AND catId = 0 AND poemId = 0 AND verseId = 0",
                                       "ORDER BY value", {type: UserActions.TypeItemListsStart})

        model.clear();
        model.append({
            "title": qsTr("Favorites"),
            "subtitle": "",
            "icon": "mdi_heart",
            "link": "float:/favorites",
            "listId": UserActions.TypeFavorite,
            "checked": selecteds? selecteds.indexOf(UserActions.TypeFavorite) >= 0 : false
        })

        lists.forEach(function(l){
            if (l.type >= UserActions.TypeItemListsEnd)
                return;

            var extra = Tools.jsonToVariant(l.extra)
            model.append({
                "title": l.value,
                "subtitle": "",
                "icon": "mdi_library",
                "link": "float:/favorites?listId=" + l.type,
                "listId": l.type,
                "checked": selecteds? selecteds.indexOf(l.type) >= 0 : false
            })
        })
    }
}
