import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls 2.0
import "../globals"

Item {

    Button {
        text: "Signup"
        anchors.centerIn: parent
        onClicked: ViewController.trigger("popup:/auth/float", {})
    }

    Header {
        id: headerItem
        color: Material.primary
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("My Meikade")
        anchors.top: parent.top
    }
}
