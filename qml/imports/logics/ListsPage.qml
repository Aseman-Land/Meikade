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

Viewport {
    id: dis

    property alias mainViewport: lists.mainViewport
    property ViewportController mainController

    property alias selectMode: lists.selectMode

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
    signal saved(variant lists)

    UserActions {
        id: listsQuery
    }

    mainItem: ListsView {
        id: lists
        anchors.fill: parent
        menuWidth: 220 * Devices.density

        headerItem.anchors.topMargin: selectMode? -Devices.statusBarHeight : 0

        premiumMsg: {
            if (Subscription.premium || Subscription.listsLimits < 0 || !Bootstrap.initialized)
                return "";

            var tgLink = "<a href='https://t.me/poshtibanimoon'>" + qsTr("Click Here") +"</a>";
            if (Bootstrap.payment && Bootstrap.trusted)
                return GTranslations.translate( qsTr("You create %1 lists from %2 lists, Allowed to create using non-premium account.").arg(lModel.count).arg(Subscription.listsLimits) )
            else
                return GTranslations.translate( qsTr("You create %1 lists from %2 lists. for more information contact us on telegram:").arg(lModel.count).arg(Subscription.listsLimits) ) + " " + tgLink
        }

        listView.model: ListsModel {
            id: lModel
            selecteds: selectMode
        }

        onPremiumBuyRequest: mainController.trigger("bottomdrawer:/account/premium/buy")

        closeBtn.onClicked: closeRequest()
        confirmBtn.onClicked: {
            var lists = new Array;
            for (var i=0; i<lModel.count; i++) {
                var item = lModel.get(i);
                var listId = item.listId;

                var currentState = (selectMode && selectMode.indexOf(listId) >= 0? true : false)
                var newState = item.checked;
                if (newState)
                    lists[lists.length] = listId;

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
            dis.saved(lists)
        }

        onPressAndHold: {
            var item = lModel.get(index);
            if (item.listId < UserActions.TypeItemListsStart)
                return;

            mainViewport.append(menuComponent, {"pointPad": pos, "item": item, "side": side}, "menu");
        }

        onClicked: {
            var item = lModel.get(index);
            Viewport.viewport.append(favoritedPoets_component, {"listId": item.listId, "title": item.title, "provider": item.subtitle, "referenceId": item.referenceId}, "page")
        }
        onAddListRequest: dis.addListRequest();

        Connections {
            target: GlobalSignals
            onListsRefreshed: lModel.refresh()
        }
    }

    Component {
        id: favoritedPoets_component
        SingleListPage {
            id: fplView
            closeBtn.visible: true
            headerBusyIndicator.running: updateModel.refreshing
            onCloseRequest: dis.closeRequest()

            property alias referenceId: updateModel.listId

            OnlineListModel {
                id: updateModel
                onLoadedSuccessfully: {
                    localId = fplView.listId;
                    follow(fplView.title, fplView.provider);
                }
            }
        }
    }

    Component {
        id: menuComponent
        MenuView {
            id: menuItem
            x: pointPad.x - width/2
            y: Math.min(pointPad.y, dis.height - height - 100 * Devices.density)
            width: lists.menuWidth
            ViewportType.transformOrigin: {
                var y = 0;
                var x;
                switch (side) {
                case 0:
                    x = width/2;
                    break;
                case 1:
                    x = width;
                    break;
                case -1:
                    x = 0;
                    break;
                }

                return Qt.point(x, y);
            }

            property point pointPad
            property int index
            property int side
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
                        enabled: menuItem.item.referenceId == undefined || menuItem.item.referenceId == 0
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
