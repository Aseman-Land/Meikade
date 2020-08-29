import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import views 1.0
import models 1.0
import queries 1.0

Viewport {
    id: dis

    property bool favoritesOnly
    property alias selectMode: lists.selectMode

    property alias poetId: listsQuery.poetId
    property alias catId: listsQuery.catId
    property alias poemId: listsQuery.poemId
    property alias verseId: listsQuery.verseId
    property string extra

    signal closeRequest()
    signal linkRequest(string link, variant properties)
    signal addListRequest()

    UserActions {
        id: listsQuery
        onLastErrorChanged: console.debug(lastError)
    }

    mainItem: ListsView {
        id: lists
        anchors.fill: parent
        listView.model: ListsModel {
            id: lModel
            selecteds: selectMode
        }
        closeBtn.onClicked: closeRequest()
        confirmBtn.onClicked: {
            for (var i=0; i<lModel.count; i++) {
                var item = lModel.get(i);
                var listId = item.listId;

                var currentState = (selectMode && selectMode.indexOf(listId) >= 0? true : false)
                var newState = item.checked;
                if (newState == currentState)
                    continue;

                listsQuery.declined = (newState? 0 : 1)
                listsQuery.type = listId;
                listsQuery.extra = extra;
                listsQuery.pushAction()
            }

            GlobalSignals.snackbarRequest(qsTr("Lists updated"));
            GlobalSignals.listsRefreshed();
            closeRequest()
        }

        onClicked: {
            var item = lModel.get(index);
            Viewport.viewport.append(favoritedPoets_component, {"listId": item.listId, "title": item.title}, "page")
        }
        onAddListRequest: dis.addListRequest()

        Connections {
            target: GlobalSignals
            onListsRefreshed: lModel.refresh()
        }

        Component.onCompleted: {
            if (favoritesOnly) {
                var obj = favoritedPoets_component.createObject(this);
                obj.anchors.fill = this;
                obj.backBtn.visible = false;

                listView.visible = false;
            }
        }
    }

    Component {
        id: favoritedPoets_component
        FavoritedPoetsListView {
            headerItem.text: title
            listView.model: FavoritedPoetsListModel { id: fplModel }
            backBtn.onClicked: ViewportType.open = false
            closeBtn.onClicked: closeRequest()
            onClicked: {
                var map = fplModel.get(index);
                var poetId = map.poetId;
                Viewport.viewport.append(favorited_component, {"poetId": poetId, "title": map.poet, "listId": listId}, "page");
            }

            property string title: qsTr("Favoriteds") + Translations.refresher
            property alias listId: fplModel.listId

            Connections {
                target: GlobalSignals
                onListsRefreshed: fplModel.refresh()
            }
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
                linkRequest(map.link, map);
            }

            Connections {
                target: GlobalSignals
                onListsRefreshed: flModel.refresh()
            }
        }
    }
}
