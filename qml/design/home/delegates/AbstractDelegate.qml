import QtQuick 2.12
import MeikadeDesign 1.0
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3

RoundedItem {
    radius: Constants.radius
    property alias button: button

    ItemDelegate {
        id: button
        anchors.fill: parent
        z: 100
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
