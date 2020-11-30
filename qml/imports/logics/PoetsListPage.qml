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
        model: {
            try {
                return modelsRepeater.itemAt(tabBar.currentIndex).modelItem;
            } catch (e) {
                return new Array;
            }
        }
    }

    tabBarRepeater.model: PoetCategoriesModel {
        id: poetCatsModel
    }

    Repeater {
        id: modelsRepeater
        model: poetCatsModel
        Item {
            property alias modelItem: poetsModel
            PoetsModel {
                id: poetsModel
                cachePath: AsemanGlobals.cachePath + "/poetslist-" + model.id + ".cache"
                typeId: model.id
            }
        }
    }
}
