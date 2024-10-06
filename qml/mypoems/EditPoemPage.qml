import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import queries 1.0 as Query
import requests 1.0
import globals 1.0
import models 1.0
import components 1.0
import "views"

EditPoemView {
    id: dis
    width: Constants.width
    height: Constants.height
    clip: true

    property int catId
    property int poemId
    property variant categories: new Array

    onPoemIdChanged: Qt.callLater(load)

    navigationRepeater.model: AsemanListModel { data: categories }

    backBtn.onClicked: ViewportType.open = false
    previewBtn.onClicked: Viewport.controller.trigger("float:/mypoems/poem", {"poemId": poemId, "previewText": editArea.text, "previewType": dis.currentType, "editMode": false})
    saveBtn.onClicked: {
        userActions.fetch();

        var extra = Tools.jsonToVariant(userActions.extra);
        extra.text = editArea.text;
        extra.type = currentType;

        try {
            extra.first_verse = editArea.text.split("\n")[0];
        } catch (e) {
            extra.first_verse = editArea.text;
        }

        userActions.extra = Tools.variantToJson(extra);
        userActions.pushAction();

        GlobalSignals.poemsRefreshed()
        ViewportType.open = false;
    }

    Query.UserActions {
        id: userActions
        type: dis.poemId
        catId: dis.catId
        poemId: -1
    }

    function load() {
        var books = userActions.getBooksItem(poemId)
        if (books.length == 0)
            return;

        let r = books[0];
        poet = MyUserRequest._fullname;
        title = r.value;
        catId = r.catId;
        userActions.poemId = r.poemId;

        var extra = Tools.jsonToVariant(r.extra);
        editArea.text = extra.text;
        currentType = extra.type;
    }
}


