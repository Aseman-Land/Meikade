import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Models 2.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: model

    property alias bookId: userActions.catId
    property bool hasPoem: false
    property bool hasBook: false

    UserActions {
        id: userActions

        Component.onCompleted: Tools.jsDelayCall(10, refresh)
    }

    Connections {
        target: GlobalSignals
        onBooksRefreshed: refresh()
    }

    function refresh() {
        var books = userActions.getBooks();

        hasBook = (books.length? true : false);

        model.clear();

        var items = new Array;
        books.forEach(function(l){
            var extra = Tools.jsonToVariant(l.extra)
            items[items.length] = {
                "title": l.value,
                "subtitle": "",
                "color": "",
                "image": "",
                "type": "fullback",
                "link": "page:/mypoems?bookId=" + l.type,
                "listId": l.type,
                "heightRatio": 0.6,
                "details": null
            };
        });

        if (items.length) {
            model.append({
                "type": bookId? "column" : "grid",
                "section": "",
                "color": "transparent",
                "background": false,
                "modelData": items
            });
        }
    }
}
