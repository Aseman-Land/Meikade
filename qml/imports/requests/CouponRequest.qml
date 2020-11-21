import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: couponRequest
    url: baseUrl + "/coupon/" + _coupon

    property string _coupon
}
