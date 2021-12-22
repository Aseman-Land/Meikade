import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: listRequest
    url: baseUrl + "/main/list/" + (_follow? "follow" : "unfollow") + "/" + _list_id

    property int _list_id
    property bool _follow

    function doRequest() {
        if (refreshing)
            return;

        networkManager.patch(listRequest)
    }
}
