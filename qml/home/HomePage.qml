import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import globals 1.0
import "views"

HomeView {
    id: home

    list {
        onLinkRequest: function(link, properties) {
            Viewport.controller.trigger(link, properties)
        }
        model: HomeModel {
            cachePath: AsemanGlobals.cachePath + "/home.cache"
        }
    }
}


