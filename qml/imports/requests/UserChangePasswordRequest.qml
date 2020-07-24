import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: homeRequest
    url: baseUrl + "/user/change-password"

    property string password
}
