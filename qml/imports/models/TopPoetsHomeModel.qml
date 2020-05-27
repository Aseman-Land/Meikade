import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: listModel

    Connections {
        target: GlobalSignals
        onTopPoetsRefreshed: actions.refresh()
    }

    MapObject {
        id: sortMap
    }

    UserActions {
        id: actions
        type: UserActions.TypeTopPoets

        function refresh() {
            sortMap.clear();
            var result = getItems(UserActions.TypeTopPoets, 0, 200);
            result.forEach( function(d) {
                if (d.declined == 1)
                    return;

                var p = Tools.jsonToVariant(d.extra);
                p["type"] = "normal";
                p["heightRatio"] = 1;

                sortMap.insert(p.title, p);
            })

            var items = new Array;
            var keys = sortMap.toMap();
            for (var i in keys)
                items[items.length] = keys[i];

            listModel.data = items;
        }

        Component.onCompleted: Tools.jsDelayCall(10, refresh)
    }
}
