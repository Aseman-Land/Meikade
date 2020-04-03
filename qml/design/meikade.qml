import QtQuick 2.12
import design 1.0
import "home"

MainForm {
    id: form
    width: Constants.width
    height: Constants.height

    HomePage {
        parent: form.homePage
        anchors.fill: parent
    }
}
