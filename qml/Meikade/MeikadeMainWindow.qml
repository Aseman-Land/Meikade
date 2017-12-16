/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    Meikade is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Meikade is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import AsemanTools 1.1
import Meikade 1.0
import QtQuick.Controls 2.1 as QtControls
import QtQuick.Controls.Material 2.1
import "globals"
import "."

AsemanWindow {
    width: 1024
    height: 680
    visible: true
    tooltip.color: MeikadeGlobals.masterColor
    tooltip.textColor: "#ffffff"
    font.family: "IRAN-sans"

    Material.theme: Meikade.nightTheme? Material.Dark : Material.Light

    MeikadeWindow {
        id: meikadeWindow
        anchors.fill: parent
    }

    CrashController {
        onCrashed: AsemanServices.sendLogs()
        Component.onCompleted: {
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
