import QtQuick 2.0
import QtQuick.Controls 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import globals 1.0

MyMeikadeView {

    gridView.model: MyMeikadeModel {}

    onClicked: Viewport.controller.trigger(link, {})
}
