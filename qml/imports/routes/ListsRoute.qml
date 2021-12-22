import QtQuick 2.12
import logics 1.0
import globals 1.0
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0

ListsPage {
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true
    width: parent.width
    height: Viewport.viewport.height * 0.7
    mainViewport: Viewport.viewport
    mainController: Viewport.controller

    onCloseRequest: ViewportType.open = false;
    onLinkRequest: Viewport.controller.trigger(link, properties)
    onAddListRequest: Viewport.controller.trigger("dialog:/lists/add")
    onRenameListRequest: Viewport.controller.trigger("dialog:/lists/add", {"actionId": actionId, "currentName": currentName})
    onDeleteListRequest: Viewport.controller.trigger("bottomdrawer:/lists/delete", {"actionId": actionId, "currentName": name, "referenceId": referenceId})
}
