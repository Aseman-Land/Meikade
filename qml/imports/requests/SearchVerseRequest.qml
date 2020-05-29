import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: searchRequest
    url: baseUrl + "/main/search/verses"

    property string query
    property int poet_id
    property int limit: 100
    property int offset: 0

    function refresh() {
        if (refreshing)
            return;

        networkManager.get(searchRequest)
    }
}

