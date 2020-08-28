import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import views 1.0
import models 1.0

Viewport {
    id: dis

    property bool favoritesOnly
    property bool selectMode: lists.selectMode

    signal closeRequest()
    signal linkRequest(string link, variant properties)
    signal addListRequest()

    mainItem: ListsView {
        id: lists
        anchors.fill: parent
        listView.model: ListsModel { id: lModel}
        closeBtn.onClicked: closeRequest()
        onClicked: {
            var item = lModel.get(index);
            Viewport.viewport.append(favoritedPoets_component, {"listId": item.listId, "title": item.title}, "page")
        }
        onAddListRequest: dis.addListRequest()

        Connections {
            target: GlobalSignals
            onFavoritesRefreshed: lModel.refresh()
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
                Viewport.viewport.append(favorited_component, {"poetId": poetId, "title": map.poet}, "page");
            }

            property string title: qsTr("Favoriteds") + Translations.refresher
            property alias listId: fplModel.listId

            Connections {
                target: GlobalSignals
                onFavoritesRefreshed: fplModel.refresh()
            }
        }
    }

    Component {
        id: favorited_component
        FavoritedListView {
            property alias poetId: flModel.poetId

            listView.model: FavoritedListModel { id: flModel }
            backBtn.onClicked: ViewportType.open = false
            closeBtn.onClicked: closeRequest()
            onClicked: {
                var map = flModel.get(index);
                linkRequest(map.link, map);
            }

            Connections {
                target: GlobalSignals
                onFavoritesRefreshed: flModel.refresh()
            }
        }
    }
}
