import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: homeRequest
    url: baseUrl + "/auth/register"

    property string username
    property string password
    property string name
    property string email
}
