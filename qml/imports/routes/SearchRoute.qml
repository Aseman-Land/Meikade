import QtQuick 2.12
import AsemanQml.Viewport 2.0
import logics 1.0

SearchPage {
    closeBtn.visible: true
    closeBtn.onClicked: ViewportType.open = false
}
