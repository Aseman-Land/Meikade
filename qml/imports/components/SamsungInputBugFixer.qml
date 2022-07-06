import QtQuick 2.0

MouseArea {
    id: dis
    anchors.fill: parent
    onPressed: {
        mouse.accepted = false;
        timerDisabled.restart();
    }

    Connections {
        target: dis.parent
        onInputMethodComposingChanged: {
            if (timerDisabled.running)
                return;
            if (!dis.parent.inputMethodComposing)
                timer.restart();
        }
    }

    Timer {
        id: timerDisabled
        interval: 1000
        repeat: false
    }

    Timer {
        id: timer
        interval: 100
        repeat: false
        onTriggered: {
            if (timerDisabled.running)
                return;
            if (dis.parent.inputMethodComposing) {
                dis.focus = true;
            }
        }
    }
}
