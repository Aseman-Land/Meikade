import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: searchRequest
    url: baseUrl + "/main/list/search"

    property string q
    property int limit: 10
    property int offset: 0

    function refresh() {
        if (q.length == 0)
            return;
        if (refreshing)
            return;

        networkManager.get(searchRequest)
    }
}

