import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Models 2.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: model

    property int bookId
    property bool hasPoem: false
    property bool hasBook: false

    UserActions {
        id: userActions

        Component.onCompleted: Tools.jsDelayCall(10, refresh)
    }

    Connections {
        target: GlobalSignals
        onBooksRefreshed: refresh()
        onPoemsRefreshed: refresh()
    }

    function refresh() {
        model.clear();

        loadBooks();
        loadPoems()
    }

    function loadBooks() {
        userActions.catId = bookId;
        userActions.poemId = 0;

        var books = userActions.getBooks();

        hasBook = (books.length? true : false);

        var booksItems = new Array;
        books.forEach(function(l){
            userActions.catId = l.type;
            userActions.poemId = -1;
            booksItems[booksItems.length] = {
                "title": l.value,
                "subtitle": userActions.getBooks().length + " poems",
                "color": "",
                "image": "",
                "type": "fullback",
                "link": "stack:/mypoems?bookId=" + l.type,
                "listId": l.type,
                "heightRatio": 0.6,
                "details": {
                    "first_verse": ""
                }
            };
        });

        if (booksItems.length) {
            model.append({
                "type": bookId? "column" : "grid",
                "section": "",
                "color": "transparent",
                "background": false,
                "modelData": booksItems
            });
        }
    }

    function loadPoems() {
        userActions.catId = bookId;
        userActions.poemId = -1;

        var poems = userActions.getBooks();

        hasPoem = (poems.length? true : false);

        var poemsItems = new Array;
        poems.forEach(function(l){
            var extra = Tools.jsonToVariant(l.extra)

            var firstVerse = "";
            try {
                var firstVerse_idx = extra.text.indexOf("\n");
                firstVerse = (firstVerse_idx > 0? extra.text.slice(0, firstVerse_idx) : extra.text);
            } catch (e) {}
            if (firstVerse.length == 0)
                firstVerse = " ";

            poemsItems[poemsItems.length] = {
                "title": l.value,
                "subtitle": "",
                "color": "",
                "image": "",
                "type": "fullback",
                "link": "stack:/mypoems/poem?poemId=" + l.type,
                "listId": l.type,
                "heightRatio": 0.6,
                "details": {
                    "first_verse": firstVerse
                }
            };
        });

        if (poemsItems.length) {
            model.append({
                "type": bookId? "column" : "grid",
                "section": "",
                "color": "transparent",
                "background": false,
                "modelData": poemsItems
            });
        }
    }
}
