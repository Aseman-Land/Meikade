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
            var list = actions.query("SELECT *, COUNT(verseId) as verses FROM actions WHERE type = :type GROUP BY poetId ORDER BY updatedAt", {type: UserActions.TypeFavorite});
            for (var i in list) {
                try {
                    var item = list[i];
                    var extraJson = Tools.jsonToVariant(item.extra);
                    extraJson["type"] = "normal";
                    extraJson["subtitle"] = qsTr("%1 items").arg(item.verses);

                    data[data.length] = extraJson;
                } catch (e) {}
            }

            dis.data = data;
        })
    }
}
