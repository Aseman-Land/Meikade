import QtQuick 2.12
import globals 1.0
import logics 1.0
import AsemanQml.Viewport 2.0

MySubBooksPage {
    width: Constants.width
    height: Constants.height

    onAddBookRequest: Viewport.controller.trigger("dialog:/mypoems/add", {"bookId": bookId})
    onAddPoemRequest: Viewport.controller.trigger("dialog:/mypoems/poem/add", {"bookId": bookId})
}
