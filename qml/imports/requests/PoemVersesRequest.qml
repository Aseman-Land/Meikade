import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: poemRequest
    url: baseUrl + "/main/verses"

    property int poem_id

    onRefreshRequest: refresh()

    function refresh() {
        if (refreshing)
            return;

        networkManager.get(poemRequest)
    }
}
