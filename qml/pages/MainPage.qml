import QtQuick 2.0
import "../design"

MainForm {
    id: form

    Home {
        parent: form.homePage
        anchors.fill: parent
    }
}
