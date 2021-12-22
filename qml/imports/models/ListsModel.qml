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
        var lists = userActions.getFullLists();

        model.clear();
        model.append({
            "title": qsTr("Favorites"),
            "subtitle": "",
            "icon": "mdi_heart",
            "link": "float:/favorites",
            "listId": UserActions.TypeFavorite,
            "checked": selecteds? selecteds.indexOf(UserActions.TypeFavorite) >= 0 : false,
            "publicList": false,
            "referenceId": 0,
            "listColor": "transparent"
        })

        lists.forEach(function(l){
            if (l.type >= UserActions.TypeItemListsEnd)
                return;

            var extra = Tools.jsonToVariant(l.extra)
            var publicList = false;
            var referenceId = 0;
            var listColor = "transparent";
            var provider = "";
            try {
                publicList = extra["public"];
                listColor = extra["listColor"];
                referenceId = extra["referenceId"];
                provider = extra["provider"];
            } catch (e) {}

            if (selecteds && referenceId)
                return;

            model.append({
                "title": l.value,
                "subtitle": provider == undefined? "" : provider,
                "icon": "mdi_library",
                "link": "float:/favorites?listId=" + l.type,
                "listId": l.type,
                "checked": selecteds? selecteds.indexOf(l.type) >= 0 : false,
                "publicList": publicList,
                "referenceId": referenceId,
                "listColor": listColor
            });
        })
    }
}
