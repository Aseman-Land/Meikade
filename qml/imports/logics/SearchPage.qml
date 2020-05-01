import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import globals 1.0

SearchView {
    id: home

    onClicked: console.debug(link)

    gridView.model: SearchModel {}

    domainBtn.onClicked: Viewport.controller.trigger("popup:/search/domains", {})
}
