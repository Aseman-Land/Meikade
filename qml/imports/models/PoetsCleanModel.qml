import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    id: listModel
    property alias refreshing: poetsReq.refreshing

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
                    res[res.length] = d;
                } catch (e) {
                }
            }
            listModel.data = res;
        }
    }
}
