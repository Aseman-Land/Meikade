import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import views 1.0
import models 1.0

PoetsListView {
    id: dis

    property string url

    Timer {
        id: initTimer
        running: true
        interval: 100
        repeat: false
    }

    headerBtn.onClicked: ViewportType.open = false

    gridView {
        onLinkRequest: Viewport.controller.trigger(link, properties)
        model: tabBar.currentIndex == 1? poetsModel_newAge : poetsModel_classic
    }

    tabBarRepeater.model: PoetCategoriesModel {
        cachePath: AsemanGlobals.cachePath + "/poetcats.cache"
    }

    PoetsModel {
        id: poetsModel_classic
        cachePath: AsemanGlobals.cachePath + "/poetslist-1.cache"
        typeId: 1
    }
    PoetsModel {
        id: poetsModel_newAge
        cachePath: AsemanGlobals.cachePath + "/poetslist-2.cache"
        typeId: 2
    }
}
