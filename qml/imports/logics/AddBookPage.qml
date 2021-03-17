import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import queries 1.0
import globals 1.0

AddBookView {
    id: home
    width: Math.min(Viewport.viewport.width * 0.9, 500*Devices.density)
    height: 230 * Devices.density
    nameField.text: currentName
    renameMode: actionId != 0

    property int bookId
    property int actionId
    property string currentName

    cancelBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: confirm()
    nameField.onAccepted: confirm()

    function confirm() {
        var actionId = home.actionId;
        if (actionId == 0) {
            actionId = UserActions.TypeItemBooksStart + Math.floor((Tools.dateToSec(new Date) - Tools.dateToSec(new Date(2020, 1, 1))) / 10);
            if (actionId < UserActions.TypeItemBooksStart || actionId >= UserActions.TypeItemBooksEnd)
                actionId = UserActions.TypeItemBooksStart + (actionId % (UserActions.TypeItemBooksEnd - UserActions.TypeItemBooksStart))
        }

        var extra = {
            "public": false
        };

        createAction.catId = bookId;
        createAction.type = actionId;
        createAction.value = nameField.text;
        createAction.extra = Tools.variantToJson(extra, true);
        createAction.pushAction();

        GlobalSignals.booksRefreshed()
        home.ViewportType.open = false;
    }

    UserActions {
        id: createAction
        poemId: 0
        poetId: 0
        declined: 0
    }
}
