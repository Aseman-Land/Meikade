import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: userRequest
    url: baseUrl + "/auth/check-username/" + _username
    allowShowErrors: false

    property string _username
}
