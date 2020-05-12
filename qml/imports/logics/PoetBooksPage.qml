import QtQuick 2.12
import AsemanQml.Viewport 2.0
import globals 1.0
import views 1.0
import models 1.0

PoetBooksView {
    width: Constants.width
    height: Constants.height

    property alias id: catsModel.poetId
    property alias catId: catsModel.parentId

    headerBtn.onClicked: ViewportType.open = false

    listView.model: CatsModel {
        id: catsModel
        cachePath: AsemanGlobals.cachePath + "/poetbook-" + poetId + "-" + parentId + ".cache"
    }
}
