import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import globals 1.0
import models 1.0
import queries 1.0
import components 1.0
import routes 1.0
import "views"

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

    mainItem: NotesPoetsListView {
        id: lists
        anchors.fill: parent
        listView.model: NotesPoetsListModel { id: fplModel }
        closeBtn.onClicked: closeRequest()
        onClicked: {
            var map = fplModel.get(index);
            var poetId = map.poetId;
            Viewport.viewport.append(note_component, {"poetId": poetId, "title": map.poet}, "stack");
        }

        Connections {
            target: GlobalSignals
            onNotesRefreshed: fplModel.refresh()
        }
    }

    Component {
        id: note_component
        NotesListView {
            property alias poetId: flModel.poetId

            listView.model: NotesListModel { id: flModel }
            backBtn.onClicked: ViewportType.open = false
            closeBtn.onClicked: closeRequest()
            onClicked: {
                var map = flModel.get(index);
                var obj = ViewController.trigger("popup:/notes/add", {"poetId": map.poetId, "catId": map.catId, "poemId": map.poemId,
                                                 "verseId": map.verseId, "poemText": "", "extra": map.extra});
                obj.saved.connect(function(text){});
                obj.poemRequest.connect(function(){
                    linkRequest(map.link, map);
                });

                if (!AsemanGlobals.helperNotePoemDone) {
                    obj.helper.next();
                    AsemanGlobals.helperNotePoemDone = true;
                }
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


