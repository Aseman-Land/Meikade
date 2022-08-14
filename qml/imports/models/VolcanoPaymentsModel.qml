import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    id: model

    property alias refreshing: req.refreshing

    GetVolcanoPaymentsRequest {
        id: req
        onSuccessfull: {
            var list = new Array;
            response.result.forEach(function(t){
                list[list.length] = t;
            });
            model.change(list);
        }
    }

    function refresh() {
        req.doRequest();
    }

    Component.onCompleted: Tools.jsDelayCall(10, refresh)
}
