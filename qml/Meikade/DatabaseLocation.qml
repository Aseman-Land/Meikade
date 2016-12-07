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

import QtQuick 2.0
import QtQuick.Controls 2.0
import AsemanTools 1.0
import AsemanTools.Awesome 1.0
import Meikade 1.0

Item {
    anchors.fill: parent

    ButtonGroup { id: radioGroup }

    AsemanListView {
        id: preference_list
        anchors.fill: parent
        anchors.topMargin: 4*Devices.density
        anchors.bottomMargin: 4*Devices.density
        highlightMoveDuration: 250
        model: ListModel {}
        delegate: Rectangle {
            id: item
            width: preference_list.width
            height: 60*Devices.density
            color: press? "#880d80ec" : "#00000000"

            property string text: name
            property alias press: marea.pressed

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10*Devices.density
                layoutDirection: View.layoutDirection
                spacing: 8*Devices.density

                RadioButton {
                    id: radioBtn
                    checked: Database.databaseLocation == model.type
                    ButtonGroup.group: radioGroup
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: "#ffffff"
                    text: item.text
                }
            }

            MouseArea{
                id: marea
                anchors.fill: parent
                onClicked: {
                    radioBtn.checked = true
                    Database.databaseLocation = model.type
                }
            }
        }

        focus: true
        Component.onCompleted: {
            model.clear()
            model.append({"name": qsTr("Internal Memory"), "type": MeikadeDatabase.ApplicationMemoryDatabase})
            model.append({"name": qsTr("External Memory"), "type": MeikadeDatabase.ExternalSdCardDatabase})
            focus = true
        }
    }

    ScrollBar {
        scrollArea: preference_list; height: preference_list.height
        anchors.right: preference_list.right; anchors.top: preference_list.top;color: "#ffffff"
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }
}
