pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0

AsemanObject {

    readonly property int notesLimits: premium? 10000000 : 5
    readonly property int listsLimits: premium? 1000 : 3
    readonly property int offlineLimits: premium? 10000000 : 3

    readonly property int premiumDays: 0
    readonly property int premium: premiumDays > 0

    function refresh() {
    }

    function init() {
        refresh()
    }
}
