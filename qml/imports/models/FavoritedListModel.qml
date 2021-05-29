import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0
import queries 1.0

AsemanListModel {
    id: dis

    property int poetId
    property int listId: UserActions.TypeFavorite

    Component.onCompleted: refresh()

    UserActions {
        id: actions
    }

    function refresh() {
        Tools.jsDelayCall(10, function(){
            var data = new Array;
            var list = actions.select("", "type = :type AND poetId = :poetId AND declined = 0", "ORDER BY updatedAt", {type: listId, poetId: poetId});
            for (var i in list) {
                try {
                    var item = list[i];
                    var extraJson = Tools.jsonToVariant(item.extra);

                    if (!extraJson.poet) extraJson["poet"] = extraJson.subtitle

                    extraJson["type"] = "normal";

                    for (var j in extraJson)
                        if (j != "extra")
                            item[j] = extraJson[j];

                    item["isVerse"] = (item.verseId == 0? false : true)
                    if (item.verseId == 0 && item.details && item.details.first_verse && !item.verseText)
                        item["verseText"] = item.details.first_verse;

                    data[data.length] = item;
                } catch (e) {console.debug(e)}
            }

            dis.data = data;
        })
    }
}
