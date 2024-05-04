import QtQuick 2.12
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0

Loader {
    id: dis
    asynchronous: false

    BusyIndicator {
        anchors.centerIn: parent
        running: dis.status == Loader.Loading
    }
}
