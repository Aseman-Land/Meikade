import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: req
    url: baseUrl + "/main/types"

    onRefreshRequest: refresh()

    function refresh() {
        if (refreshing)
            return;

        networkManager.get(req)
    }
}
