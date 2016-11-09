import QtQuick 2.0
import AsemanTools 1.1
import Meikade 1.0
import "."

AsemanWindow {
    width: 1024
    height: 680
    visible: true

    Connections {
        target: Meikade
        onLanguageDirectionChanged: View.layoutDirection = Meikade.languageDirection
        Component.onCompleted: View.layoutDirection = Meikade.languageDirection
    }

    MeikadeWindow {
        anchors.fill: parent
    }
}
