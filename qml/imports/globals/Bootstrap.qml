pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0

AsemanObject {
    id: bstrap

    readonly property bool initialized: false

    function refresh() {
    }

    function init() {
        refresh()
    }
}
