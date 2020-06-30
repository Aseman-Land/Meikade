import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: req
    url: baseUrl + "/main/app/feedback"

    property string email
    property string name
    property string description
}
