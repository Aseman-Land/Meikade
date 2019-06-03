pragma Singleton

import QtQuick 2.0
import Falcon.Base 1.0 as Falcon
import AsemanClient.Services 1.0 as Services
import QtQuick 2.7
import AsemanQml.Base 2.0

AsemanObject {
    property alias socket: asemanSocket
    property alias meikade: asemanMeikade

    readonly property int meikadeAppId: 35816
    readonly property bool loggedIn: false

    signal incommingMessage(string message, string msgUrl)

    Falcon.ClientSocket {
        id: asemanSocket
        hostAddress: "meikade.com"
        autoTrust: true
        certificate: "../certificates/falcon.crt"
        onError: console.debug("AsemanServices.qml: ", errorCode, errorValue)
        onGeneralError: console.debug("AsemanServices.qml: ", text)
    }

    Services.Meikade {
        id: asemanMeikade
        socket: asemanSocket
    }

    Settings {
        id: messagesSettings
        source: AsemanApp.homePath + "/messages.ini"
        category: "General"
    }

    Timer {
        id: checkMessageTimer
        interval: 5*60*1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            meikade.lastMessage(function(res, error){
                if(res.uuid) {
                    if(messagesSettings.value(res.uuid, 0) == 1)
                        return

                    incommingMessage(res.message, res.urlAction)
                    messagesSettings.setValue(res.uuid, 1)
                }
            })
        }
        Component.onCompleted: restart()
    }

    function init() {
        asemanSocket.wake()
    }

    function sendLogs() {
        var log = Tools.readText(Logger.path)
        meikade.submiteLog(Devices.deviceId, Devices.platformType, AsemanApp.applicationVersion, log, null);
    }

    function checkLogs() {
        var txt = "SQL Error"
        var log = Tools.readText(Logger.path)
        var idx = log.indexOf(txt)
        if(idx != -1)
            sendLogs()
    }
}
