import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: listModel
    property alias refreshing: poetsReq.refreshing

    function append(poetId, properties) {
        actions.poetId = poetId;
        actions.declined = false;
        actions.extra = Tools.variantToJson(properties, true);
        actions.updatedAt = Tools.dateToSec(new Date);
        actions.push();
        GlobalSignals.topPoetsRefreshed();
    }
    function remove(poetId) {
        actions.poetId = poetId;
        actions.declined = true;
        actions.updatedAt = Tools.dateToSec(new Date);
        actions.push();
        GlobalSignals.topPoetsRefreshed();
    }

    HashObject {
        id: actionsHash
    }

    UserActions {
        id: actions
        type: UserActions.TypeTopPoets

        function refresh() {
            actionsHash.clear()
            var result = getItems(UserActions.TypeTopPoets, 0, 200);
            result.forEach( function(r) {
                if (r.declined == 0)
                    actionsHash.insert(r.poetId, r);
            })
        }

        Component.onCompleted: Tools.jsDelayCall(10, refresh)
    }

    SimplePoetsRequest {
        id: poetsReq
        onResponseChanged: {
            if (!poetsReq.response)
                return;

            var res = new Array;
            for (var j in poetsReq.response.result) {
                try {
                    var d = poetsReq.response.result[j];
                    d["title"] = d.name;
                    d["subtitle"] = "";
                    d["catId"] = 0;
                    d["image"] = Constants.thumbsBaseUrl + d.id + ".png";
                    d["checked"] = actionsHash.contains(d.id);
                    res[res.length] = d;
                } catch (e) {
                }
            }
            listModel.data = res;
        }
    }
}
