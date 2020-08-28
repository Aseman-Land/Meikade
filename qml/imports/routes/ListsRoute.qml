import QtQuick 2.12
import logics 1.0
import globals 1.0
import AsemanQml.Viewport 2.0

ListsPage {
    width: parent.width
    height: Viewport.viewport.height * 0.7

    onCloseRequest: ViewportType.open = false;
    onLinkRequest: Viewport.controller.trigger(link, properties)
    onAddListRequest: Viewport.controller.trigger("bottomdrawer:/lists/add")
}
