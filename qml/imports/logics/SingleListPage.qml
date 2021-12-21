import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0
import views 1.0
import models 1.0
import queries 1.0
import micros 1.0
import routes 1.0

FavoritedPoetsListView {
    id: fplView
    headerItem.text: title
    listView.model: flatList? flModel : fplModel
    publicList: fplModel.publicList
    listColor: fplModel.listColor
    flatList: fplModel.flatList
    onPublicListSwitch: fplModel.publicList = checked
    onColorSwitch: fplModel.listColor = color
    onFlatListSwitched: fplModel.flatList = state
    closeBtn.visible: false
    closeBtn.onClicked: closeRequest()
    backBtn.onClicked: ViewportType.open = false
    onClicked: {
        var map = listView.model.get(index);
        if (flatList) {
            ViewController.trigger(map.link, map);
        } else {
            var poetId = map.poetId;
            Viewport.viewport.append(favorited_component, {"poetId": poetId, "title": map.poet, "listId": listId}, "page");
        }
    }

    Behavior on gradientColor {
        ColorAnimation { easing.type: Easing.OutCubic; duration: 500 }
    }

    FavoritedPoetsListModel {
        id: fplModel
        listId: onlineList? 0 : fplView.listId
        onSavingStarted: fplView.publicIndicatorState = true
        onSavingFinished: fplView.publicIndicatorState = false
    }
    FavoritedListModel {
        id: flModel
        listId: flatList? fplModel.listId : 0
        onListIdChanged: refresh()
    }

    property string title: qsTr("Favoriteds") + Translations.refresher
    property int listId

    signal closeRequest()

    Component.onCompleted: {
        if (!disableSharing && !AsemanGlobals.helperListsDone) {
            helper.next();
            AsemanGlobals.helperListsDone = true;
        }
    }

    Component {
        id: favorited_component
        FavoritedListView {
            property alias poetId: flModel.poetId
            property alias listId: flModel.listId

            listView.model: FavoritedListModel { id: flModel }
            backBtn.onClicked: ViewportType.open = false
            closeBtn.onClicked: closeRequest()
            onClicked: {
                var map = flModel.get(index);
                ViewController.trigger(map.link, map);
            }
        }
    }
}
