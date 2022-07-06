import QtQuick 2.0
import AsemanQml.Base 2.0

AsemanObject {

    property date startDate: new Date

    function getMs() {
        return Tools.dateToMSec(new Date) - Tools.dateToMSec(startDate);
    }

    function reset() {
        startDate = new Date;
    }

    Component.onCompleted: reset()
}
