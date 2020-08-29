import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import queries 1.0
import globals 1.0

DeleteListView {
    id: home
    width: parent.width
    height: 240 * Devices.density

    property int actionId
    property string currentName
    property int count

    rejectBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: confirm()

    bodyLabel.text: qsTr("Are you sure about delete \"%1\"?\nIt containts %2 items currently.").arg(currentName).arg(count) + Translations.refresher

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
