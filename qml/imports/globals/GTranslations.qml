pragma Singleton

import QtQuick 2.7
import AsemanQml.Base 2.0

TranslationManager {
    id: translationManager
    sourceDirectory: "translations/"
    delimiters: "-"
    fileName: "lang"
    localeName: AsemanGlobals.language

    function refreshLayouts() {
        if(localeName == "fa")
            CalendarConv.calendar = 1
        else
            CalendarConv.calendar = 0
    }

    function init() {}

    Component.onCompleted: refreshLayouts()
    onLocaleNameChanged: refreshLayouts()
}
