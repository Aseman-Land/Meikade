import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0
import queries 1.0

AsemanListModel {
    id: dis

    property int listId: UserActions.TypeFavorite
    property bool publicList: false
    property string listColor: "transparent"

    Component.onCompleted: refresh()
    onPublicListChanged: save()
    onListColorChanged: save()

    function save() {
        if (obj.signalBlocker)
            return;

        var current = actions.query("SELECT extra FROM actions WHERE type = :type AND declined = 0 AND poetId = 0 AND catId = 0 AND poemId = 0 AND verseId = 0", {"type": listId})
        var extra = Tools.toVariantMap( Tools.jsonToVariant(current[0].extra) );
        extra["public"] = publicList;
        extra["listColor"] = listColor;
        extra = Tools.variantToJson(extra);

        actions.query("UPDATE actions SET extra = :extra WHERE type = :type AND declined = 0 AND poetId = 0 AND catId = 0 AND poemId = 0 AND verseId = 0", {"type": listId, "extra": extra});
        GlobalSignals.listsRefreshed();
    }

    UserActions {
        id: actions
    }

    QtObject {
        id: obj

        property bool signalBlocker
    }

    function refresh() {
        Tools.jsDelayCall(10, function(){
            var data = new Array;
            var current = actions.query("SELECT extra FROM actions WHERE type = :type AND declined = 0 AND poetId = 0 AND catId = 0 AND poemId = 0 AND verseId = 0", {"type": listId})

            obj.signalBlocker = true;
            publicList = false;
            listColor = "transparent"

            try {
                var extra = Tools.jsonToVariant(current[0].extra);
                publicList = extra["public"];
                listColor = extra["listColor"];
            } catch (e) {}
            obj.signalBlocker = false;

            var list = actions.query("SELECT *, COUNT(verseId) as verses FROM actions WHERE type = :type AND declined = 0 GROUP BY poetId ORDER BY updatedAt", {"type": listId});
            for (var i in list) {
                try {
                    var item = list[i];
                    if (!item.poetId && !item.catId && !item.poemId && !item.verseId)
                        continue;

                    var extraJson = Tools.jsonToVariant(item.extra);

                    if (!extraJson.poet) extraJson["poet"] = extraJson.subtitle

                    extraJson["type"] = "normal";
                    extraJson["subtitle"] = qsTr("%1 items").arg(item.verses);

                    for (var j in extraJson)
                        if (j != "extra")
                            item[j] = extraJson[j];

                    data[data.length] = item;
                } catch (e) {}
            }

            dis.data = data;
        })
    }
}
