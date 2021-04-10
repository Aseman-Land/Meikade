import QtQuick 2.12
import logics 1.0
import globals 1.0
import AsemanQml.Viewport 2.0

NotesPage {
    width: parent.width
    height: Viewport.viewport.height * 0.7
    mainViewport: Viewport.viewport
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true

    onCloseRequest: ViewportType.open = false;
    onLinkRequest: Viewport.controller.trigger(link, properties)
    onAddListRequest: Viewport.controller.trigger("dialog:/lists/add")
    onRenameListRequest: Viewport.controller.trigger("dialog:/lists/add", {"actionId": actionId, "currentName": currentName})
    onDeleteListRequest: Viewport.controller.trigger("bottomdrawer:/lists/delete", {"actionId": actionId, "currentName": name})
}
