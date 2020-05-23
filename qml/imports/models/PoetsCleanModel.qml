import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    property alias refreshing: poetsReq.refreshing

    data: {
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
                    d["image"] = Constants.thumbsBaseUrl + caps[0][1] + ".png";
                    res[res.length] = d;
                }
            }
        } catch (e) {
        }
        return res;
    }

    PoetsRequest {
        id: poetsReq
    }
}
