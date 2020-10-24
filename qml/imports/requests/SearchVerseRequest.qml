import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: searchRequest
    url: baseUrl + "/main/search/verses?query=" + _query + "&limit=" + _limit + "&offset=" + _offset

    property variant poets
    property string _query
    property int _limit: 50
    property int _offset: 0

    function refresh() {
        if (_query.length == 0)
            return;
        if (refreshing)
            return;

        networkManager.post(searchRequest)
    }
}

