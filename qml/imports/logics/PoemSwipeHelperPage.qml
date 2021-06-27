import QtQuick 2.0
import views 1.0
import globals 1.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0

PoemSwipeHelperView {
    width: Viewport.viewport.width
    okBtn.onClicked: ViewportType.open = false
}
