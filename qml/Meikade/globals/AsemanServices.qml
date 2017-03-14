pragma Singleton

import QtQuick 2.0
import AsemanServer 1.0 as Server
import QtQuick 2.7
import AsemanTools 1.0

AsemanObject {
    property alias socket: asemanSocket
    property alias auth: asemanAuth
    property alias meikade: asemanMeikade

    signal incommingMessage(string message, string msgUrl)

    Server.ClientSocket {
        id: asemanSocket
//        hostAddress: "127.0.0.1"
        autoTrust: true
        certificate: "../certificates/falcon.crt"
    }

    Server.Auth {
        id: asemanAuth
        socket: asemanSocket
    }

    Server.Meikade {
        id: asemanMeikade
        socket: asemanSocket
    }

    Settings {
        id: messagesSettings
        category: "General"
        source: AsemanApp.homePath + "/messages.ini"
    }

    Timer {
        id: checkMessageTimer
        interval: 5*60*1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            meikade.lastMessage(function(res, error){
                if(res.uuid) {
                    if(messagesSettings.value(res.uuid, 0) == 0)
                        return

                    incommingMessage(res.message, res.urlAction)
                    messagesSettings.setValue(res.uuid, 1)
                    messageDialog.show(network_message_component, {"message":message, "destUrl":url})
                }
            })
        }
        Component.onCompleted: restart()
    }

    function init() {
        asemanSocket.wake()
    }
}
