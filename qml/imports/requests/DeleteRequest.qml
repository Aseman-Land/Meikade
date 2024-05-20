import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    url: baseUrl + "/user"

    property string password

    function doRequest() {
        networkManager.deleteMethod(this)
    }
}
