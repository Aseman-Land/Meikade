import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: publishRequest
    url: baseUrl + "/user/action/unpublish"

    property int category_id
    property int poem_id

    function doRequest() {
        networkManager.post(publishRequest)
    }
}
