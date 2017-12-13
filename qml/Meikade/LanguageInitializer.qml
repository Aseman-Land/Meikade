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
import AsemanTools 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import "globals"

Popup {
    id: popup
    x: parent.width/2 - width/2
    y: parent.height/2 - height/2
    modal: true
    focus: true

    onVisibleChanged: {
        if(visible) {
            BackHandler.pushHandler(popup, function(){popup.visible = false})
        } else {
            BackHandler.removeHandler(popup)
            Tools.jsDelayCall(500, function(){popup.destroy()})
        }
    }

    contentItem:  ColumnLayout {
        id: column

        Label {
            color: "#333333"
            font.pixelSize: 20*Devices.density
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Language"
        }

        AsemanListView {
            id: listViewTumbler
            height: 200*Devices.density
            Layout.minimumWidth: 200*Devices.density
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            model: ListModel {}
            delegate: RadioButton {
                text: model.name
                checked: MeikadeGlobals.localeName == model.code
                width: listViewTumbler.width
                onClicked: {
                    if(!checked)
                        return

                    MeikadeGlobals.localeName = model.code
                    listViewTumbler.currentIndex = index
                }
            }

            Component.onCompleted: {
                model.clear()

                var langs = MeikadeGlobals.translator.translations
                for(var l in langs)
                    model.append({"code": l, "name": langs[l]})

                focus = true
            }
        }

        Button {
            id: okButton
            text: "Ok"
            onClicked: popup.close()

            Material.foreground: Material.LightBlue
            Material.background: "transparent"
            Material.elevation: 0

            Layout.preferredWidth: 0
            Layout.fillWidth: true
        }
    }
}
