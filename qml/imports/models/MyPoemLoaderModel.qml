import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0
import components 1.0

AsemanObject {
    id: dis

    property int poemId
    property int poetId
    property int catId

    property string link
    property string title
    property string poet
    property string previewText
    property int previewType: -1

    property alias categoriesModel: categoriesModel
    property alias versesModel: versesModel

    onPoemIdChanged: Qt.callLater(refresh)

    Connections {
        target: GlobalSignals
        onPoemsRefreshed: refresh()
    }

    function refresh() {
        var books = userActions.getBooksItem(poemId)
        if (books.length == 0)
            return;

        let r = books[0];

        dis.title = r.value;
        dis.poetId = 0;
        dis.catId = r.catId;
        dis.poet = MyUserRequest._fullname;
        dis.link = "page:/mypoems?poemId=" + r.type;
        dis.poemId = r.type;

        categoriesModel.clear();
        categoriesModel.append({
            title: MyUserRequest._fullname,
            id: 0,
            link: "page:/mypoems"
        });

        var parent_cat = r.catId;
        do {
            var cats = userActions.getBooksItem(parent_cat);
            if (cats.length == 0)
                break;

            let c = cats[0];
            categoriesModel.insert(1, {
                title: c.value,
                id: c.type,
                link: "page:/mypoems?bookId=" + parent_cat
            });

            parent_cat = c.catId;
        } while (parent_cat);

        let extra = Tools.jsonToVariant(r.extra);
        let verses = (previewText.length? previewText : extra.text).split("\n");
        let type = (previewType >= 0? previewType : (extra.type == undefined? 0 : extra.type));

        versesModel.clear();
        for (var vi=0; vi<verses.length; vi++) {
            var text = verses[vi];
            if (text.trim().length == 0)
                continue;

            var pos;
            switch (type) {
            case PoemTypeIcon.TypeLeftRight:
                pos = (vi % 2);
                if (text[0] == ':') {
                    pos += 2;
                    text = text.slice(1);
                }
                break;

            case PoemTypeIcon.TypeNormalText:
                pos = 4;
                if (text[0] == ':') {
                    text = text.slice(1);
                }
                break;

            case PoemTypeIcon.TypeLeftRight_LTR:
                pos = -1 * ((vi % 2) + 1);
                if (text[0] == ':') {
                    pos -= 2;
                    text = text.slice(1);
                }
                break;

            case PoemTypeIcon.TypeNormalText_LTR:
                pos = -5;
                if (text[0] == ':') {
                    text = text.slice(1);
                }
                break;
            }

            var v = {
                "text": text,
                "vorder": vi,
                "position": pos,
                "favorited": false,
                "hasNote": false,
                "hasList": false,
            };
            v.text = Tools.stringReplace(v.text, "\\s+", " ", true);
            versesModel.append(v);
        };
    }

    AsemanListModel {
        id: categoriesModel
        property bool refreshing: false
    }
    AsemanListModel {
        id: versesModel
        property bool refreshing: false

        function refresh() {
            poemReq.refresh()
        }
    }

    UserActions {
        id: userActions
        type: dis.poemId
    }
}
