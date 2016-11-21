/*
    Copyright (C) 2015 Nile Group
    http://nilegroup.org

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

import QtQuick 2.7
import AsemanTools 1.0

AsemanApplication {
    id: app
    applicationName: "Meikade"
    applicationAbout: "Persian Poetry App"
    applicationDisplayName: "Meikade"
    applicationVersion: "v3.5.0"
    applicationId: "7e861c79-2b50-427b-93b6-4591b54eb821"
    organizationDomain: "NileGroup"
    organizationName: "Aseman Team"
    windowIcon: "icons/meikade.png"

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
