import QtQuick 2.12
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0
import models 1.0

PoetView {
    width: Constants.width
    height: Constants.height

    property alias id: catsModel.poetId

    gridView.model: CatsModel {
        id: catsModel
    }

    bioBtn.onClicked: Viewport.controller.trigger("popup:/poet/bio")
    menuBtn.onClicked: ViewportType.open = false
}
