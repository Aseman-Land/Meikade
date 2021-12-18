import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: publishRequest
    url: baseUrl + "/user/action/publish"

    property int poet_id
    property int verse_id
    property int category_id
    property int poem_id
    property int type

    function doRequest() {
        networkManager.post(publishRequest)
    }
}
