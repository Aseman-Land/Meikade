import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: req
    url: baseUrl + "/messages"

    function doRequest() {
        networkManager.get(this);
    }
}
