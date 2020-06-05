import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import requests 1.0
import globals 1.0

Item {
    property int poetId
    property int catId

    Timer {
        interval: 10
        repeat: false
        running: true
        onTriggered: {
            RandomPoemRequest.random(poetId, catId);
            Tools.jsDelayCall(10, function(){ ViewportType.open = false; });
        }
    }
}
