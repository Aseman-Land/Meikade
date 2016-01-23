import QtQuick 2.0
import AsemanTools 1.0

AsemanObject {
    id: analizer

    property string comment
    property variant object
    property string objectName

    onObjectChanged: if(object) objectName = Tools.className(object)

    Timer {
        id: timer
        interval: 100
        repeat: true
        onTriggered: count++
        Component.onCompleted: begin()

        property int count
    }

    function begin() {
        timer.count = 0
        timer.restart()
    }

    function end() {
        if(!timer.running)
            return

        timer.stop()
        networkFeatures.pushActivity(objectName, timer.count*100, comment)
    }

    Component.onDestruction: end()
}

