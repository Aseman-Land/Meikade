import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import views 1.0
import models 1.0

PoetsListView {

    headerBtn.onClicked: ViewportType.open = false

    gridView.model: PoetsModel {
        cachePath: AsemanGlobals.cachePath + "/poetslist.cache"
    }

    tabBarRepeater.model: PoetCategoriesModel {
        cachePath: AsemanGlobals.cachePath + "/poetcats.cache"
    }
}
