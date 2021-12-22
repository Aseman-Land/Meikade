import QtQuick 2.12
import logics 1.0
import globals 1.0
import requests 1.0
import models 1.0
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0

Viewport {
    id: vport
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true
    width: parent.width
    height: Viewport.viewport.height * 0.7

    property int listId
    property string title
    property variant user

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
        followBtn.visible: provider != MyUserRequest._fullname
        followBtn.onClicked: {
            if (listModel.localId)
                listModel.unfollow(dis.title, dis.provider);
            else
                listModel.follow(dis.title, dis.provider);
        }

        listView.model: listModel

        OnlineListModel {
            id: listModel
            listId: vport.listId
        }
    }
}
