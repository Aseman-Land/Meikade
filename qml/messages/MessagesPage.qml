import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import "views"

MessagesView {
    width: Viewport.viewport.width
    cancelBtn.onClicked: ViewportType.open = false
    listView.model: MessagesModel
    onLinkClicked: {
        Viewport.controller.trigger(link);
    }
}


