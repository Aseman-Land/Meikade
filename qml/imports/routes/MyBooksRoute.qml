import QtQuick 2.12
import logics 1.0
import globals 1.0
import AsemanQml.Viewport 2.0

MyBooksPage {
    width: Constants.width
    height: Constants.height

    onAddBookRequest: Viewport.controller.trigger("dialog:/mypoems/add")
}
