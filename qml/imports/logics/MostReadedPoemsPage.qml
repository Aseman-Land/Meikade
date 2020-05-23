import QtQuick 2.12
import AsemanQml.Viewport 2.0
import views 1.0
import models 1.0
import queries 1.0 as Query
import globals 1.0

MostReadedPoemsView {
    id: dis
    width: Constants.width
    height: Constants.height

    closeBtn.onClicked: ViewportType.open = false

    onClicked: Viewport.controller.trigger(link, properties)

    listView.model: RecentsModel {
        limit: 100
        type: {
            switch (dis.tabBar.currentIndex) {
            case 2:
                return Query.UserActions.TypePoetViewDate
            case 1:
                return Query.UserActions.TypeCatViewDate
            default:
            case 1:
                return Query.UserActions.TypePoemViewDate
            }

        }
    }
}
