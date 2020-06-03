import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: poetsRequest
    url: baseUrl + "/main/poet"

    property int poet_id

    onPoet_idChanged: Tools.jsDelayCall(10, refresh)
    onRefreshRequest: refresh()

    function refresh() {
        if (refreshing)
            return;

        networkManager.get(poetsRequest)
    }
}
