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
        actions.extra = Tools.variantToJson(properties);
        actions.updatedAt = Tools.dateToSec(new Date);
        actions.pushAction();
        GlobalSignals.topPoetsRefreshed();
    }
    function remove(poetId) {
        actions.poetId = poetId;
        actions.declined = true;
        actions.updatedAt = Tools.dateToSec(new Date);
        actions.pushAction();
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

    PoetsRequest {
        id: poetsReq
        onResponseChanged: {
            var res = new Array;
            try {
                for (var i in poetsReq.response.result) {
                    var modelData = poetsReq.response.result[i].modelData;
                    for (var j in modelData) {
                        var d = modelData[j];
                        var caps = Tools.stringRegExp(d.link, "^\\w+\\:\\/poet\\?id\\=(\\d+)$");
                        if (caps.length === 0)
                            continue;

                        d["id"] = caps[0][1];
                        d["catId"] = 0;
                        d["checked"] = actionsHash.contains(d.id);
                        d["image"] = Constants.thumbsBaseUrl + caps[0][1] + ".png";
                        d["subtitle"] = GTranslations.translate(d.subtitle);
                        res[res.length] = d;
                    }
                }

                listModel.data = res;
            } catch (e) {
            }
        }
    }
}
