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

import QtQuick 2.7
import AsemanTools 1.0
import QtQuick.Controls 2.1 as QtControls
import Meikade 1.0
import AsemanTools.Awesome 1.0
import AsemanClient.CoreServices 1.0 as CoreServices
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "globals"

Item {
    clip: true

    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    property int type
    property int category: 1

    onCategoryChanged: gmodel.clear()

    CoreServices.GeneralModel {
        id: gmodel
        agent: AsemanServices.meikade
        method: AsemanServices.meikade.name_getStoreItems
        arguments: [
            MeikadeGlobals.localeName, "", category, offset, limit, Database.poetsDates
        ]
        uniqueKeyField: "id"
    }

    AsemanListView {
        id: listv
        anchors.fill: parent
        topMargin: spacing
        model: gmodel
        spacing: 8*Devices.density

        footer: Item {
            width: listv.width
            height: listv.height/3

            QtControls.BusyIndicator {
                anchors.centerIn: parent
                height: 48*Devices.density
                width: height
                running: gmodel.refreshing
            }

            Column {
                anchors.centerIn: parent
                visible: !gmodel.refreshing && gmodel.errorCode

                QtControls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: gmodel.errorValue? gmodel.errorValue : ""
                }

                QtControls.Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Refresh")
                    onClicked: {
                        gmodel.clear()
                        gmodel.refresh()
                    }
                }
            }
        }

        delegate: Item {
            x: listv.spacing
            width: listv.width - 2*x
            height: 54*Devices.density

            ItemPane {
                anchors.fill: parent
            }

            PoetInstaller {
                id: installer
                poetId: model.poetId
                date: model.date
                socket: AsemanServices.socket
                source: model.path
            }

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 16*Devices.density
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10*Devices.density
                layoutDirection: View.layoutDirection

                Item {
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.preferredHeight: 40*Devices.density
                    Layout.preferredWidth: Layout.preferredHeight

                    Rectangle {
                        id: mask
                        anchors.fill: parent
                        visible: false
                        radius: 8*Devices.density
                    }

                    CoreServices.RemoteImage {
                        id: poetImg
                        anchors.fill: parent
                        visible: false
                        fillMode: Image.PreserveAspectFit
                        socket: AsemanServices.socket
                        receiveMethod: CoreServices.RemoteFile.ReceiveMediaNormal
                        source: model.thumb
                        destination: {
                            var path = Meikade.thumbsPath
                            Tools.mkDir(path)
                            return Devices.localFilesPrePath + path + "/" + model.poetId + ".png"
                        }
                    }

                    OpacityMask {
                        anchors.fill: parent
                        source: poetImg
                        maskSource: mask
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.fillWidth: true

                    text: model.name
                    horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                    font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: MeikadeGlobals.foregroundColor
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: Meikade.nightTheme? Qt.darker(MeikadeGlobals.foregroundColor) : Qt.lighter(MeikadeGlobals.foregroundColor)
                    text: {
                        if(installer.installing)
                            return qsTr("Installing")
                        else
                        if(installer.uninstalling)
                            return qsTr("Removing")
                        else
                        if(installer.downloading)
                            return qsTr("Downloading")
                        else
                        if(installer.updateAvailable)
                            return qsTr("Update")
                        else
                        if(installer.installed)
                            return qsTr("Installed")
                        else
                        if(installer.error.length)
                            return installer.error
                        else
                            return qsTr("Free")
                    }
                }

                Item {
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: Layout.preferredHeight

                    Text {
                        id: img
                        anchors.centerIn: parent
                        font.pixelSize: 15*globalFontDensity*Devices.fontDensity
                        font.family: Awesome.family
                        color: {
                            if(installer.updateAvailable)
                                return "#0d80ec"
                            else
                            if(installer.installed)
                                return "#3c994b"
                            else
                                return Meikade.nightTheme? Qt.darker(MeikadeGlobals.foregroundColor) : Qt.lighter(MeikadeGlobals.foregroundColor)
                        }
                        text: {
                            if(installer.updateAvailable)
                                return Awesome.fa_download
                            else
                            if(installer.installed)
                                return Awesome.fa_check_square_o
                            else
                                return Awesome.fa_plus
                        }
                        visible: !indicator.running
                    }

                    QtControls.BusyIndicator {
                        id: indicator
                        anchors.centerIn: parent
                        width: 48*Devices.density
                        height: width
                        scale: 0.5
                        transformOrigin: Item.Center
                        running: installer.installing || installer.uninstalling || installer.downloading
                    }
                }
            }

            ProgressBar {
                width: parent.width
                height: 3*Devices.density
                anchors.bottom: parent.bottom
                visible: indicator.running && !installer.uninstalling
                percent: 100*installer.progress
                transform: Scale { origin.x: width/2; origin.y: height/2; xScale: View.defaultLayout?1:-1}
                color: "#00000000"
            }

            Rectangle {
                width: parent.width
                height: 1*Devices.density
                color: MeikadeGlobals.backgroundColor
                anchors.bottom: parent.bottom
            }

            QtControls.ItemDelegate {
                id: marea
                anchors.fill: parent
                onClicked: {
                    if(installer.installed) {
                        if(!indicator.running) {
                            removePopup.poetName = model.name
                            removePopup.updateCallback = installer.updateAvailable? function(){ installer.install() } : null
                            removePopup.deleteCallback = function(){ installer.remove() }
                            removePopup.open()
                        }

                        return
                    }

                    installer.install()
                    AsemanServices.meikade.pushAction( ("Poet Download: %1").arg(model.poetId), null )
                }
            }

            Component.onCompleted: if(index == listv.count-20) gmodel.more()
        }
    }

    ScrollBar {
        scrollArea: listv; height: listv.height; anchors.right: listv.right;
        anchors.top: listv.top; color: "#111111"
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }
}
