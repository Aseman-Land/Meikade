import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    id: listModel
    property alias refreshing: poetsReq.refreshing

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

                        var id = caps[0][1];
                        if (id > 1000 && !Bootstrap.initialized)
                            continue;

                        d["id"] = id;
                        d["catId"] = 0;
                        d["subtitle"] = GTranslations.translate(d.subtitle);
                        d["image"] = Constants.thumbsBaseUrl + caps[0][1] + ".png";
                        res[res.length] = d;
                    }
                }

                listModel.clear();
                res.forEach(listModel.append)
            } catch (e) {
            }
        }
    }

    function refresh() {
        poetsReq.refresh();
    }
}
