import QtQuick 2.9
import AsemanQml.Controls.Beta 3.0
import AsemanQml.Base 2.0
import globals 1.0

BusyIndicator {
    property bool light
    Style.foregroundColor: light? "#fff" : Colors.foreground
}
