import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import models 1.0
import requests 1.0
import "views"

SyncView {
    id: dis

    property variant lastSync: Tools.datefromString(AsemanGlobals.lastSync, "yyyy-MM-dd hh:mm:ss")

    closeBtn.onClicked: ViewportType.open = false

    resyncBtn.visible: AsemanGlobals.introDone
    resyncBtn.onClicked: StoreActionsBulk.forceResync()

    syncDateLabel.text: AsemanGlobals.lastSync.length? Tools.trNums( CalendarConv.convertDateTimeToLittleString(lastSync) ) : (syncIndicator.running? qsTr("Syncing...") : "---")
    syncTimeLabel.text: AsemanGlobals.lastSync.length? Tools.trNums( Tools.dateToString(lastSync, "hh:mm:ss" ) ) : ""

    syncBtn.onClicked: StoreActionsBulk.syncActionsInterval()
    syncIndicator.running: StoreActionsBulk.syncing

    mypoemsSwitch.checked: AsemanGlobals.syncMyPoems
    mypoemsSwitch.onCheckedChanged: if (!initTimer.running) { AsemanGlobals.syncMyPoems = mypoemsSwitch.checked; StoreActionsBulk.syncActionsInterval(); AsemanGlobals.lastSync = "" }

    syncListsSwitch.checked: AsemanGlobals.syncFavorites
    syncListsSwitch.onCheckedChanged: if (!initTimer.running) { AsemanGlobals.syncFavorites = syncListsSwitch.checked; StoreActionsBulk.syncActionsInterval(); AsemanGlobals.lastSync = "" }

    syncNotesSwitch.checked: AsemanGlobals.syncNotes
    syncNotesSwitch.onCheckedChanged: if (!initTimer.running) { AsemanGlobals.syncNotes = syncNotesSwitch.checked; StoreActionsBulk.syncActionsInterval(); AsemanGlobals.lastSync = "" }

    syncPoemsSwitch.checked: AsemanGlobals.syncViews
    syncPoemsSwitch.onCheckedChanged: if (!initTimer.running) { AsemanGlobals.syncViews = syncPoemsSwitch.checked; StoreActionsBulk.syncActionsInterval(); AsemanGlobals.lastSync = "" }

    syncTopPoetsSwitch.checked: AsemanGlobals.syncTopPoets
    syncTopPoetsSwitch.onCheckedChanged: if (!initTimer.running) { AsemanGlobals.syncTopPoets = syncTopPoetsSwitch.checked; StoreActionsBulk.syncActionsInterval(); AsemanGlobals.lastSync = "" }

    Timer {
        id: initTimer
        interval: 1000
        repeat: false
        running: true
    }
}


