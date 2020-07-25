import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Network 2.0
import globals 1.0

BaseRequest {
    id: homeRequest
    contentType: NetworkRequest.TypeForm
    url: baseUrl + "/user/upload"

    property url file
}
