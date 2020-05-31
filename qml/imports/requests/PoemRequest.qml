import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: myUserReq
    url: baseUrl + "/main/poem"

    property int poem_id
    property int verse_limit: 1000
    property int verse_offset: 0
}
