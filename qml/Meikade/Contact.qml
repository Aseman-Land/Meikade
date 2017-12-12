/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    TelegramStats is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TelegramStats is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import AsemanTools 1.1
import AsemanTools.MaterialIcons 1.0
import QtQuick 2.5
import QtQuick.Controls 2.1 as QtControls
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "globals"

QtControls.Page {
    anchors.fill: parent

    AndroidListEffect {
        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        flickable: Devices.isDesktop? flick : null

        AsemanFlickable {
            id: flick
            anchors.fill: parent
            flickableDirection: Flickable.VerticalFlick
            contentHeight: column.height + 20*Devices.density
            contentWidth: width
            clip: true

            ColumnLayout {
                id: column
                width: flick.width - 20*Devices.density
                anchors.centerIn: parent

                QtControls.TextField {
                    id: fName
                    placeholderText: qsTr("Full name")
                    horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    Layout.fillWidth: true
                }

                QtControls.TextField {
                    id: email
                    placeholderText: qsTr("Email")
                    horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    Layout.fillWidth: true
                }

                QtControls.TextArea {
                    id: body
                    placeholderText: qsTr("Your Message")
                    horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    Layout.fillWidth: true
                    Layout.preferredHeight: 128*Devices.density

                    TextCursorArea { textItem: body }
                }

                QtControls.Button {
                    Layout.fillWidth: true
                    text: qsTr("Send")
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    highlighted: true
                    enabled: fName.length && email.length && body.length
                    onClicked: {
                        if(fName.length < 3) {
                            showTooltip( qsTr("Name is too short") )
                            return
                        }
                        if(email.length < 3) {
                            showTooltip( qsTr("Email is too short") )
                            return
                        }
                        if(body.length < 10) {
                            showTooltip( qsTr("Your message is too short") )
                            return
                        }

                        indicator.running = true
                        AsemanServices.meikade.contactUs(fName.text, email.text, body.text, Devices.deviceId, function(res, error){
                            indicator.running = false
                            if(res) {
                                BackHandler.back()
                                showTooltip( qsTr("Your message sent") )
                            } else {
                                showTooltip( qsTr("Can't send your message") )
                            }
                        })
                    }
                    Material.accent: MeikadeGlobals.masterColor
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#88ffffff"
        visible: indicator.running

        NullMouseArea {
            anchors.fill: parent
        }

        QtControls.BusyIndicator {
            id: indicator
            anchors.centerIn: parent
            running: false
            height: 48*Devices.density
            width: height
            transformOrigin: Item.Center
        }
    }

    Header {
        id: header
        width: parent.width
        color: MeikadeGlobals.masterColor
        titleFont.pixelSize: 10*Devices.fontDensity
        text: qsTr("Contact")
    }
}
