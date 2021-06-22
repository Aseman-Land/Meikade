import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: homeRequest
    url: baseUrl + "/main/explore"

    onRefreshRequest: refresh()

    function refresh() {
        if (refreshing)
            return;

        networkManager.get(homeRequest)
    }
}
