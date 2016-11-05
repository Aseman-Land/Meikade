import QtQuick 2.7
import AsemanTools 1.0

AsemanApplication {
    id: app
    applicationName: "Meikade"
    applicationAbout: "Persia Poetry App"
    applicationDisplayName: "Meikade"
    applicationVersion: "v3.3.0"
    applicationId: "7e861c79-2b50-427b-93b6-4591b54eb821"
    organizationDomain: "NileGroup"
    organizationName: "Aseman Team"

    property variant appMain

    Component.onCompleted: { // Control app to run one instance
        if(app.isRunning) {
            console.debug("Another instance is running. Trying to make that visible...")
            Tools.jsDelayCall(1, function(){
                app.sendMessage("show")
                app.exit(0)
            })
        } else {
            var component = Qt.createComponent("MeikadeMainWindow.qml", Component.Asynchronous);
            var callback = function(){
                if(component.status == Component.Ready)
                    appMain = component.createObject(app)
                else if(component.status == Component.Error) {
                    console.error(component.errorString())
                }
            }
            component.statusChanged.connect(callback)
            callback()
        }
    }
}
