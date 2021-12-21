import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: listRequest
    url: baseUrl + "/main/list/" + _list_id

    property int _list_id

    on_List_idChanged: Tools.jsDelayCall(10, refresh)
    onRefreshRequest: refresh()

    function refresh() {
        if (refreshing)
            return;

        networkManager.get(listRequest)
    }
}
