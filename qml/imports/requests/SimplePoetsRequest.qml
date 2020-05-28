import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: poetsRequest
    url: baseUrl + "/main/poets-simple"

    property int offset: 0
    property int limit: 200
    property int type_id: 0

    onType_idChanged: Tools.jsDelayCall(10, refresh)
    onRefreshRequest: refresh()

    function refresh() {
        if (refreshing)
            return;

        networkManager.get(poetsRequest)
    }
}
