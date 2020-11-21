import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: packagesRequest
    url: baseUrl + "/payment/package"

    property int package_id
    property string coupon_uid
}
