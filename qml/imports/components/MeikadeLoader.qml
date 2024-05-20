import QtQuick 2.12
import QtQuick.Controls 2.3

Loader {
    id: dis
    asynchronous: false

    BusyIndicator {
        anchors.centerIn: parent
        running: dis.status == Loader.Loading
    }
}
