import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import globals 1.0

HomeView {
    id: home

    list {
        onLinkRequest: Viewport.controller.trigger(link, properties)
        model: HomeModel {
            cachePath: AsemanGlobals.cachePath + "/home.cache"
        }
    }
}
