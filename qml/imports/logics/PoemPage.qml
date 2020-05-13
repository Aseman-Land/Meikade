import QtQuick 2.12
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0
import models 1.0

PoemView {
    width: Constants.width
    height: Constants.height

    property alias poemId: poemModel.poemId
    property alias navigData: navigModel.data

    AsemanListModel {
        id: navigModel
        data: []
    }

    Behavior on coverScene.y {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
    }

    navigationRepeater.model: navigModel

    menuBtn.onClicked: ViewportType.open = false

    gridView.model: PoemVersesModel {
        id: poemModel
        cachePath: AsemanGlobals.cachePath + "/poem-" + poemId + ".cache"
        Component.onCompleted: console.debug(AsemanGlobals.cachePath + "/poem-" + poemId + ".cache")
    }
}