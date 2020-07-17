import QtQuick 2.12
import logics 1.0
import globals 1.0

SyncPage {
    width: Constants.width
    height: Constants.height

    property bool allowResync: true

    resyncBtn.visible: allowResync
}
