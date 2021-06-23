import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    id: lmodel

    property alias refreshing: sugReq.refreshing

    HashObject {
        id: newsHash
    }

    GetSuggestionsRequest {
        id: sugReq
        onSuccessfull: {
            newsHash.clear();
            for (var i in response.result) {
                let m = response.result[i];
                newsHash.insert(m.id, m);
            }

            var arr = new Array;
            for (var j in lmodel.data) {
                let m2 = lmodel.data[j];
                if (!newsHash.contains(m2.id))
                    continue;

                arr[arr.length] = newsHash.value(m2.id);
                newsHash.remove(m2.id);
            }

            for (var i in response.result) {
                let m = response.result[i];
                if (!newsHash.contains(m.id))
                    continue;

                arr[arr.length] = m;
            }

            lmodel.data = arr;
        }
    }

    function refresh() { sugReq.refresh() }

    Component.onCompleted: refresh()
}
