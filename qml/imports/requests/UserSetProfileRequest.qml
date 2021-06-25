import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: homeRequest
    url: baseUrl + "/user/image/" + _image

    property string _image

    function doRequest() {
        networkManager.put(this);
    }
}
