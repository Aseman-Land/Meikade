pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

AsemanObject {

    LoggerRequest { id: req }

    function log(action, valInt, valStr) {
        if (loggerPath.length == 0)
            return;

        req.date_time = new Date;
        req.action_id = action;
        req.value_int = valInt;
        req.value_str = valStr;
        req.networkManager.post(req)
    }
}
