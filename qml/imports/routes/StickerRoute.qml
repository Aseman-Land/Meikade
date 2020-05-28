import QtQuick 2.12
import logics 1.0
import globals 1.0
import AsemanQml.Viewport 2.0

Viewport {
    property alias text: dialog.text
    property alias poet: dialog.poet

    mainItem: StickerDialog {
        id: dialog
        anchors.fill: parent
    }
}
