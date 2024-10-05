import QtQuick 2.12
import globals 1.0
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0
import ".."

NotesPage {
    width: parent.width
    height: Viewport.viewport.height * 0.7
    mainViewport: Viewport.viewport
    ViewportType.maximumWidth: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : 0
    ViewportType.touchToClose: true

    onCloseRequest: ViewportType.open = false;
    onLinkRequest: function(link, properties) {
        Viewport.controller.trigger(link, properties)
    }
    onAddListRequest: Viewport.controller.trigger("dialog:/lists/add")
    onRenameListRequest: Viewport.controller.trigger("dialog:/lists/add", {"actionId": actionId, "currentName": currentName})
    onDeleteListRequest: Viewport.controller.trigger("blurbottomdrawer:/lists/delete", {"actionId": actionId, "currentName": name})
}

