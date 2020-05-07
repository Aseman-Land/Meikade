pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import queries 1.0

AsemanObject {

    Timer {
        id: syncTimer
        interval: 60 * 1000
        triggeredOnStart: true
        repeat: true
        running: true
        onTriggered: {

        }
    }
}
