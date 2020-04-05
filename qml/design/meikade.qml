import QtQuick 2.12
import MeikadeDesign 1.0
import "home"

MainForm {
    id: form
    width: Constants.width
    height: Constants.height

    HomeDemo {
        parent: form.homePage
        anchors.fill: parent
    }
}
