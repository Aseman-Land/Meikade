import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: catsRequest
    url: baseUrl + "/main/categories"

    property int poet_id
    property int parent_id
    property int offset
    property int limit: 50

    onRefreshRequest: refresh()

    function refresh() {
        if (refreshing || poet_id == 0)
            return;

        offset = 0;
        networkManager.get(catsRequest)
    }
}
