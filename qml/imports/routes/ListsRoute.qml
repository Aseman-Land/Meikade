import QtQuick 2.12
import logics 1.0
import globals 1.0
import AsemanQml.Viewport 2.0

ListsPage {
    width: Constants.width
    height: Constants.height

    onCloseRequest: ViewportType.open = false;
}
