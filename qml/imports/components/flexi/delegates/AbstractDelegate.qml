import QtQuick 2.12
import globals 1.0
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3

Item {
    id: del
    property real radius: Constants.radius
    property alias button: button

    Rectangle {
        anchors.fill: parent
        radius: del.radius
        color: Colors.foreground
        opacity: button.pressed? 0.1 : 0
        z: 100
    }

    MouseArea {
        id: button
        anchors.fill: parent
        z: 100
    }
}
