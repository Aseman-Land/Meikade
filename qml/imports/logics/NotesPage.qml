import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import globals 1.0
import views 1.0
import models 1.0
import queries 1.0
import micros 1.0

Viewport {
    id: dis

    property Viewport mainViewport

    property alias poetId: listsQuery.poetId
    property alias catId: listsQuery.catId
    property alias poemId: listsQuery.poemId
    property alias verseId: listsQuery.verseId
    property string extra

    signal closeRequest()
    signal linkRequest(string link, variant properties)
    signal addListRequest()
    signal renameListRequest(int actionId, string currentName)
    signal deleteListRequest(int actionId, string name)

    UserActions {
        id: listsQuery
    }

    mainItem: NotesListView {
        id: lists
        anchors.fill: parent
//        listView.model: FavoritedPoetsListModel { id: fplModel }
        closeBtn.onClicked: closeRequest()
        onClicked: {
            var map = fplModel.get(index);
            var poetId = map.poetId;
            Viewport.viewport.append(favorited_component, {"poetId": poetId, "title": map.poet, "listId": listId}, "page");
        }

        Connections {
            target: GlobalSignals
            onNotesRefreshed: fplModel.refresh()
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
                onNotesRefreshed: flModel.refresh()
            }
        }
    }

    Component {
        id: menuComponent
        MenuView {
            id: menuItem
            x: pointPad.x - width/2
            y: Math.min(pointPad.y, dis.height - height - 100 * Devices.density)
            width: 220 * Devices.density
            ViewportType.transformOrigin: {
                var y = 0;
                var x = width/2;
                return Qt.point(x, y);
            }

            property point pointPad
            property int index
            property variant item

            onItemClicked: {
                switch (index) {
                case 0:
                    renameListRequest(item.listId, item.title);
                    break;
                case 1:
                    deleteListRequest(item.listId, item.title);
                    break;
                }

                ViewportType.open = false;
            }

            model: AsemanListModel {
                data: [
                    {
                        title: qsTr("Change Name"),
                        icon: "mdi_rename_box",
                        enabled: true
                    },
                    {
                        title: qsTr("Delete"),
                        icon: "mdi_delete",
                        enabled: true
                    }
                ]
            }
        }
    }
}
