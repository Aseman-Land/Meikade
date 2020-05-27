import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import views 1.0
import models 1.0

Viewport {

    signal closeRequest()
    signal linkRequest(string link, variant properties)

    mainItem: ListsView {
        anchors.fill: parent
        listView.model: ListsModel { id: lModel}
        closeBtn.onClicked: closeRequest()
        onClicked: Viewport.viewport.append(favoritedPoets_component, {}, "page")

        Connections {
            target: GlobalSignals
            onFavoritesRefreshed: lModel.refresh()
        }
    }

    Component {
        id: favoritedPoets_component
        FavoritedPoetsListView {
            listView.model: FavoritedPoetsListModel { id: fplModel }
            backBtn.onClicked: ViewportType.open = false
            closeBtn.onClicked: closeRequest()
            onClicked: {
                var map = fplModel.get(index);
                var poetId = map.poetId;
                Viewport.viewport.append(favorited_component, {"poetId": poetId}, "page");
            }

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
