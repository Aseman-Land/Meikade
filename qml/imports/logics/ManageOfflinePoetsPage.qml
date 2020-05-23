import QtQuick 2.12
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0
import models 1.0

ManageOfflinePoetsView {
    width: Constants.width
    height: Constants.height

    closeBtn.onClicked: ViewportType.open = false

    listView.model: {
        switch (tabBar.currentIndex) {
        case 1:
            return catsModel;
        default:
        case 0:
            return poetsModel;
        }
    }

    PoetsCleanModel {
        id: poetsModel
        cachePath: AsemanGlobals.cachePath + "/poetsofflinelist.cache"
    }

    OfflineCatsModel {
        id: catsModel
    }
}
