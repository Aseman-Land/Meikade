import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

BaseRequest {
    id: req
    url: loggerPath + "/api/v1/meikade/logs"
    allowGlobalBusy: false
    allowShowErrors: false

    property string device_id: Devices.deviceId
    property date date_time
    property string action_id
    property int value_int
    property string value_str
    property string os_type: Devices.platformName
    property string device_type: Devices.deviceName

    function log(action, valInt, valStr) {
        date_time = new Date;
        action_id = action;
        value_int = valInt;
        value_str = valStr;
        networkManager.post(req)
    }
}

