import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import requests 1.0
import queries 1.0
import globals 1.0
import "views"

DeleteListView {
    id: home
    width: parent.width
    height: 240 * Devices.density

    property alias referenceId: followReq._list_id;
    property int actionId
    property string currentName
    property int count

    rejectBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: {
        if (referenceId)
            followReq.doRequest();
        else {
            var items = createAction.getListItem(actionId);
            try {
                if (items.length != 1)
                    throw false;

                var item = items[0];
                var extra = Tools.jsonToVariant(item.extra)
                if (extra["public"] != true)
                    throw false;

                unpubReq.poet_id = item.poetId;
                unpubReq.category_id = item.catId;
                unpubReq.poem_id = item.poemId;
                unpubReq.verse_id = item.verseId;
                unpubReq.type = actionId;
                unpubReq.doRequest();
            } catch (e) {
                confirm();
            }
        }
    }

    bodyLabel.text: qsTr("Are you sure about delete \"%1\"?\nIt containts %2 items currently.").arg(currentName).arg(count) + Translations.refresher


    ListFollowRequest {
        id: followReq
        allowGlobalBusy: true
        _follow: false
        onSuccessfull: confirm()
    }

    UnpublishListRequest {
        id: unpubReq
        allowGlobalBusy: true
        onSuccessfull: confirm()
    }

    function confirm() {
        createAction.declined = 1;
        createAction.pushAction();
        GlobalSignals.snackbarRequest( qsTr("\"%1\" deleted").arg(currentName) );
        GlobalSignals.listsRefreshed();
        home.ViewportType.open = false;
    }

    UserActions {
        id: createAction
        type: actionId
        Component.onCompleted: {
            var lists = select("", "type = :type AND declined = 0 AND (poetId > 0 OR catId > 0 OR poemId > 0 OR verseId > 0)", "", {type: actionId})
            count = lists.length;
        }
    }
}


