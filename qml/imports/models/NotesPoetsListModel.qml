import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0
import queries 1.0

AsemanListModel {
    id: dis

    Component.onCompleted: refresh()

    UserActions {
        id: actions
    }

    function refresh() {
        Tools.jsDelayCall(10, function(){
            var data = new Array;
            var list = actions.query("SELECT *, COUNT(verseId) as verses FROM actions WHERE type = :type AND declined = 0 GROUP BY poetId ORDER BY updatedAt", {type: UserActions.TypeNote});
            for (var i in list) {
                try {
                    var item = list[i];
                    if (!item.poetId && !item.catId && !item.poemId && !item.verseId)
                        continue;

                    var extraJson = Tools.jsonToVariant(item.extra);

                    if (!extraJson.poet) extraJson["poet"] = extraJson.subtitle

                    extraJson["type"] = "normal";
                    extraJson["subtitle"] = qsTr("%1 notes").arg(GTranslations.translate(item.verses));

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
