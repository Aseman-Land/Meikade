import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import queries 1.0
import globals 1.0

AddListView {
    id: home
    width: parent.width
    height: 300 * Devices.density

    cancelBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: {
        var actionId = UserActions.TypeItemListsStart + Tools.dateToSec(new Date) - Tools.dateToSec(new Date(2020, 1, 1))
        if (actionId < UserActions.TypeItemListsStart || actionId >= UserActions.TypeItemListsEnd)
            actionId = UserActions.TypeItemListsStart + (actionId % (UserActions.TypeItemListsEnd - UserActions.TypeItemListsStart))

        var extra = {
            "public": false
        };

        createAction.type = actionId;
        createAction.value = nameField.text;
        createAction.extra = Tools.variantToJson(extra, true);
        createAction.pushAction();

        GlobalSignals.listsRefreshed()
        home.ViewportType.open = false;
    }

    UserActions {
        id: createAction
        type: UserActions.TypeListCreate
        poemId: 0
        poetId: 0
        declined: 0
    }
}
