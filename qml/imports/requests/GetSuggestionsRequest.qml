import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: actionsRequest
    url: baseUrl + "/suggestion/suggestions"

    function refresh() {
        networkManager.get(actionsRequest)
    }
}
