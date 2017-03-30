pragma Singleton

import QtQuick 2.0
import AsemanServer 1.0 as Server
import QtQuick 2.7
import AsemanTools 1.0

AsemanObject {
    property alias socket: asemanSocket
    property alias auth: asemanAuth
    property alias meikade: asemanMeikade
    property alias authSettings: auth_settings

    readonly property int meikadeAppId: 35816
    readonly property bool loggedIn: auth_settings.sessionId.length
    property bool sessionActivated: false

    signal incommingMessage(string message, string msgUrl)

    Server.ClientSocket {
        id: asemanSocket
//        hostAddress: "127.0.0.1"
        autoTrust: true
        certificate: "../certificates/falcon.crt"
        onConnected: activeSession()
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
        id: auth_settings
        category: "General"
        source: AsemanApp.homePath + "/auth.ini"

        property string sessionId
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

    function activeSession(callback) {
        if(!loggedIn)
            return

        auth.activeSession(auth_settings.sessionId, meikadeAppId, function(res, error) {
            if(res) {
                View.root.showTooltip( qsTr("Logged In :)") )
                sessionActivated = true
            } else {
                switch(error.code) {
                case Server.Auth.ErrorIncorrectSession:
                case Server.Auth.ErrorIncorrectAppId:
                case Server.Auth.ErrorExpiredSession:
                    authSettings.sessionId = ""
                    sessionActivated = false
                    break;
                }

                View.root.showTooltip( qsTr("Login error :(") + "\n" + error.value )
            }
            if(callback != undefined) callback()
        })
    }
}
