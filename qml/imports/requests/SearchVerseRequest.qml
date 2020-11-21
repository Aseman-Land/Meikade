import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: searchRequest
    url: baseUrl + "/main/search/verses?query=" + _query + "&limit=" + _limit + "&offset=" + _offset + "&smart=" + _smart

    property variant poets
    property string _query
    property int _limit: 50
    property int _offset: 0
    property string _smart: "true"

    property string _lastQuery

    onSuccessfull:{
        if (_lastQuery != _query)
            Tools.jsDelayCall(10, refresh)
    }

    function refresh() {
        if (_query.length == 0)
            return;
        if (refreshing)
            return;

        _lastQuery = _query;
        networkManager.post(searchRequest)
    }
}

