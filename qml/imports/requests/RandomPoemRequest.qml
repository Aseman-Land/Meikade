import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: catsRequest
    url: baseUrl + "/main/random-poem"

    property int poet_id
    property int category_id
    property int verse_offset
    property int verse_limit: 1000

    function refresh() {
        if (refreshing)
            return;

        networkManager.get(catsRequest)
    }
}
