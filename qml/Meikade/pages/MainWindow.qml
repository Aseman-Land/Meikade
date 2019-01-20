import QtQuick 2.0
import AsemanQml.Base 2.0
import Meikade 1.0
import QtQuick.Controls 2.1 as QtControls
import QtQuick.Controls.Material 2.1
import "../globals"

AsemanWindow {
    width: 500
    height: 700
    visible: true
    tooltip.color: MeikadeGlobals.masterColor
    tooltip.textColor: "#ffffff"
    font.family: "IRAN-sans"

    Material.theme: Meikade.nightTheme? Material.Dark : Material.Light

    Loader {
        id: loader
        anchors.fill: parent
        asynchronous: true
        Component.onCompleted: {
            if(MeikadeGlobals.iosStyle)
                source = "MainWindow_ios.qml"
            else
                source = "MainWindow_android.qml"
        }
    }

    Rectangle {
        anchors.fill: parent
        color: MeikadeGlobals.masterColor
        opacity: loader.status == Loader.Ready? 0 : 1

        QtControls.BusyIndicator {
            width: 64*Devices.density
            height: width
            anchors.centerIn: parent
            running: loader.status != Loader.Ready
            Material.accent: "#fff"
        }

        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
        }
    }

    CrashController {
        id: crashController
        onCrashed: AsemanServices.sendLogs()
        Component.onCompleted: {
            AsemanServices.checkLogs()
            Logger.start()
            Logger.debug("Log started: %1".arg(Logger.path))
        }
    }

    Component.onCompleted: {
        DownloaderQueue.destination = AsemanApp.homePath + "/cache"
        AsemanServices.init()
        checkChangelog()
    }

    function checkChangelog() {
        if(MeikadeGlobals.lastCheckedVersion.length && AsemanApp.applicationVersion != MeikadeGlobals.lastCheckedVersion) {
            AsemanServices.meikade.getChangeLog(Devices.platformType, AsemanApp.applicationVersion, function(res, error){
                if(!error.null) return
                var text = qsTr("<h3>Changelog:</h3><br />%1").arg(res)
                meikadeWindow.showMessage(text, "")
                MeikadeGlobals.lastCheckedVersion = AsemanApp.applicationVersion
            })
        } else {
            AsemanServices.meikade.getLastVersion(Devices.platformType, function(res, error){
                if(!error.null) return

                var version = res.version
                var notify = res.notify
                var changelog = res.changelog
                var storeLink = res.storeLink

                if(MeikadeGlobals.lastUpdateCheckedVersion.length == 0 || version == AsemanApp.applicationVersion) {
                    MeikadeGlobals.lastUpdateCheckedVersion = version
                }
                if(MeikadeGlobals.lastUpdateCheckedVersion == version)
                    return

                var text = qsTr("<h3>New version:</h3><br />%1").arg(changelog)
                meikadeWindow.showMessage(text, storeLink).okText = qsTr("Update")
                MeikadeGlobals.lastUpdateCheckedVersion = version
            })
        }
    }
}
