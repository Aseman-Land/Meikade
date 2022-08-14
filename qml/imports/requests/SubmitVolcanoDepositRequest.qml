import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Network 2.0
import globals 1.0

BaseRequest {
    id: req
    contentType: NetworkRequest.TypeJson
    url: baseUrl + "/users/me/volcano/deposit"

    property int amount_msat: 0

    function doRequest() {
        _networkManager.post(req)
    }
}
