import QtQuick 2.12
import globals 1.0
import requests 1.0
import queries 1.0
import models 1.0
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0
import ".."

Viewport {
    id: vport
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true
    width: parent.width
    height: Viewport.viewport.height * 0.7

    property int listId
    property string title
    property variant user

    UserActions {
        id: userActions
    }

    mainItem: SingleListPage {
        id: dis
        anchors.fill: parent
        title: vport.title
        provider: user.name

        disableSharing: true
        onlineList: true
        listColor: listModel.listColor
        flatList: listModel.flatList
        followState: listModel.localId > 0
        onFlatListSwitched: listModel.flatList = state
        onCloseRequest: vport.ViewportType.open = false;

        backBtn.onClicked: vport.ViewportType.open = false;
        followBtn.visible: Bootstrap.subscription && provider != MyUserRequest._fullname
        followBtn.enabled: Bootstrap.payment && Bootstrap.trusted
        followBtn.onClicked: {
            if (!Subscription.premium && userActions.getLists().length >= Subscription.listsLimits && listModel.localId == 0) {
                ViewController.trigger("blurbottomdrawer:/account/premium/buy")
                return;
            }

            if (listModel.localId)
                listModel.unfollowOnline(dis.title, dis.provider);
            else
                listModel.followOnline(dis.title, dis.provider);
        }

        listView.model: listModel

        OnlineListModel {
            id: listModel
            listId: vport.listId
        }
    }
}

