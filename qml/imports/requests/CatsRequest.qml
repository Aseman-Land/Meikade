import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: catsRequest
    url: baseUrl + "/main/categories"

    property int poet_id
    property int parent_id

    onRefreshRequest: refresh()

    function refresh() {
        if (refreshing)
            return;

        networkManager.get(catsRequest)
    }
}
