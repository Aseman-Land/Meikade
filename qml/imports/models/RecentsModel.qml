import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0
import queries 1.0

AsemanListModel {
    id: dis

    property int type

    onTypeChanged: refresh()
    Component.onCompleted: refresh()

    Connections {
        target: RefresherSignals
        onRecentPoemsRefreshed: refresh()
    }

    UserActions {
        id: actions
    }

    function refresh() {
        Tools.jsDelayCall(10, function(){
            var data = new Array;
            var list = actions.getItems(type, 0, 10);
            for (var i in list) {
                try {
                    var item = list[i];
                    var extraJson = Tools.jsonToVariant(item.extra);
                    extraJson["type"] = "normal";

                    data[data.length] = extraJson;
                } catch (e) {}
            }

            dis.data = data;
        })
    }
}
