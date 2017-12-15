pragma Singleton

import QtQuick 2.0
import AsemanClient 1.0 as Client
import AsemanClient.CoreServices 1.0 as CoreServices
import AsemanClient.Services 1.0 as Services
import QtQuick 2.7
import AsemanTools 1.0

AsemanObject {
    property alias socket: asemanSocket
    property alias meikade: asemanMeikade

    readonly property int meikadeAppId: 35816
    readonly property bool loggedIn: false

    signal incommingMessage(string message, string msgUrl)

    Client.ClientSocket {
        id: asemanSocket
//        hostAddress: "aseman.co"
        autoTrust: true
        certificate: "../certificates/falcon.crt"
        onError: console.debug("AsemanServices.qml: ", errorCode, errorValue)
        onGeneralError: console.debug("AsemanServices.qml: ", text)
    }

    Services.Meikade {
        id: asemanMeikade
        socket: asemanSocket
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
