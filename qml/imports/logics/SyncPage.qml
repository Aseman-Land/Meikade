import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import views 1.0
import models 1.0
import requests 1.0

SyncView {
    id: dis
    closeBtn.onClicked: ViewportType.open = false

    property variant lastSync: Tools.datefromString(AsemanGlobals.lastSync, "yyyy-MM-dd hh:mm:ss")

    syncDateLabel.text: Tools.trNums( CalendarConv.convertDateTimeToLittleString(lastSync) )
    syncTimeLabel.text: Tools.trNums( Tools.dateToString(lastSync, "hh:mm:ss" ) )

    syncBtn.onClicked: StoreActionsBulk.syncActionsInterval()
    syncIndicator.running: StoreActionsBulk.syncing
}
