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
    headerTitle.text: title
    headerProvider.text: provider

    listView.model: flatList? flModel : fplModel
    publicList: fplModel.publicList
    listColor: fplModel.listColor
    flatList: fplModel.flatList
    favoriteMode: listId == UserActions.TypeFavorite
    disableSharing: fplModel.referenceId > 0 || listId == UserActions.TypeFavorite

    onPublicListSwitch: fplModel.publicList = checked
    onColorSwitch: fplModel.listColor = color
    onFlatListSwitched: fplModel.flatList = state

    closeBtn.visible: false
    closeBtn.onClicked: closeRequest()
    backBtn.onClicked: ViewportType.open = false
    onClicked: {
        var map = listView.model.get(index);
        if (flatList) {
            ViewController.trigger(map.link, prepareNeighbors(map, listView, index));
        } else {
            var poetId = map.poetId;
            if (map.childs)
                Viewport.viewport.append(favorited_component, {"poetId": poetId, "title": map.poet, "childs": map.childs}, "page");
            else
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
    property string provider
    property int listId

    signal closeRequest()

    Timer {
        interval: 500
        repeat: false
        running: true
        onTriggered: {
            if (!favoriteMode && !disableSharing && !AsemanGlobals.helperListsDone) {
                helper.next();
                AsemanGlobals.helperListsDone = true;
            }
        }
    }

    Component {
        id: favorited_component
        FavoritedListView {
            property alias poetId: flModel.poetId
            property alias listId: flModel.listId
            property alias childs: customModel.data

            listView.model: listId? flModel : customModel
            backBtn.onClicked: ViewportType.open = false
            closeBtn.onClicked: closeRequest()
            onClicked: {
                var map = listView.model.get(index);
                ViewController.trigger(map.link, prepareNeighbors(map, listView, index));
            }

            FavoritedListModel { id: flModel; listId: 0 }
            AsemanListModel { id: customModel }
        }
    }

    function prepareNeighbors(map, listView, index) {
        var properties = Tools.toVariantMap(map);

        var neighbors = new Array;
        for (var i=0; i<listView.model.count; i++) {
            var n = listView.model.get(i);
            try {
                neighbors[neighbors.length] = {
                    "link": n.link,
                    "subtitle": "0 poems",
                    "title": n.title,
                    "verseId": n.verseId,
                    "poet": n.poet
                };
            } catch(e) {}
        }

        properties["neighbors"] = neighbors;
        properties["neighborsIndex"] = index;

        return properties;
    }
}
