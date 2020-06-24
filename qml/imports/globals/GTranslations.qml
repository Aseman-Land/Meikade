pragma Singleton

import QtQuick 2.7
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0

AsemanObject {
    id: translationManager

    property alias model: model
    property alias localeName: mgr.localeName
    property alias textDirection: mgr.textDirection

    AsemanListModel {
        id: model
        data: {
            var res = new Array;
            var list = mgr.translations;
            for (var i in list) {
                var title = list[i];
                if (title === "American English")
                    title = "English"

                res[res.length] = {
                    "title": title,
                    "key": i
                }
            }
            return res
        }
    }

    TranslationManager {
        id: mgr
        sourceDirectory: "translations/"
        delimiters: "-"
        fileName: "lang"
        localeName: AsemanGlobals.language

        Component.onCompleted: refreshLayouts()
        onLocaleNameChanged: refreshLayouts()
    }

    function translate(str) {
        switch (str) {
        case "All Poets":
            str = qsTr("All Poets");
            break;
        case "Random Poem":
            str = qsTr("Random Poem");
            break;
        case "Hafez Divination":
            str = qsTr("Hafez Divination");
            break;
        }

        str = Tools.stringReplace(str, "Books", qsTr("Books"), false);
        str = Tools.stringReplace(str, "books", qsTr("Books"), false);
        str = Tools.stringReplace(str, "Poems", qsTr("Poems"), false);
        str = Tools.stringReplace(str, "poems", qsTr("Poems"), false);
        str = Tools.stringReplace(str, "\\s+", " ", true);
        str = Tools.trNums(str);
        return str;
    }

    function refreshLayouts() {
        if(mgr.localeName == "fa")
            CalendarConv.calendar = 1
        else
            CalendarConv.calendar = 0
    }

    function init() {}
}
