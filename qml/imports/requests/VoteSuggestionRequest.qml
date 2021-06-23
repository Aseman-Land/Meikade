import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    url: baseUrl + "/suggestion/vote/" + _suggestion_id

    property int _suggestion_id

    function doRequest() {
        networkManager.post(this)
    }
}
