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
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.3
import Meikade 1.0
import AsemanTools 1.0
import AsemanTools.Awesome 1.0
import "globals"

Item {
    width: 100
    height: 62
    anchors.fill: parent

    Connections {
        target: Backuper
        onSuccess: {
            prefrences.refresh()
        }
    }

    AsemanListView {
        id: prefrences
        anchors.fill: parent
        anchors.topMargin: 4*Devices.density
        anchors.bottomMargin: 4*Devices.density
        spacing: 7*Devices.density
        highlightMoveDuration: 250
        clip: true
        model: ListModel {}
        delegate: Rectangle {
            id: item
            x: prefrences.spacing
            width: prefrences.width - 2*prefrences.spacing
            height: txt.height + 30*Devices.density
            color: "transparent"

            property string file: path
            property alias press: marea.pressed

            onPressChanged: hideRollerDialog()

            MaterialFrame {
                anchors.fill: parent
                color: Qt.lighter("#313131")
            }

            Text{
                id: txt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 30*Devices.density
                y: parent.height/2 - height/2
                font.pixelSize: 11*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#ffffff"
                text: Meikade.fileName(item.file)
                wrapMode: TextInput.WordWrap
            }

            MouseArea{
                id: marea
                anchors.fill: parent
                onClicked: {
                    Backuper.restore(item.file)
                }
            }

            Button {
                id: delete_btn
                height: parent.height
                width: height
                iconHeight: 22*Devices.density
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10*Devices.density
                normalColor: "#00000000"
                highlightColor: "#3d3d3d"
                onClicked: {
                    removePopup.filePath = item.file
                    removePopup.open()
                }

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 15*globalFontDensity*Devices.fontDensity
                    font.family: Awesome.family
                    color: Qt.lighter(MeikadeGlobals.masterColor)
                    text: Awesome.fa_close
                }
            }
        }

        header: Item {
            id: header
            width: prefrences.width
            height: 100*Devices.density + title.height

            Text {
                id: title
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10*Devices.density
                font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#ffffff"
                wrapMode: TextInput.WordWrap
            }

            Button {
                id: header_back
                anchors.top: title.bottom
                anchors.margins: 10*Devices.density
                anchors.horizontalCenter: header.horizontalCenter
                width: header.width - 20*Devices.density
                height: 40*Devices.density

                MaterialFrame {
                    anchors.fill: parent
                    color: Qt.lighter("#313131")
                }

                property alias press: hmarea.pressed

                Text{
                    id: backup_txt
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 10*Devices.density
                    y: parent.height/2 - height/2
                    font.pixelSize: 11*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: "#ffffff"
                }

                MouseArea{
                    id: hmarea
                    anchors.fill: parent
                    onClicked: {
                        Backuper.makeBackup()
                    }
                }
            }

            Rectangle{
                id: splitter
                anchors.bottom: header.bottom
                anchors.left: header.left
                anchors.right: header.right
                anchors.bottomMargin: 7*Devices.density
                height: message.height
                color: Qt.lighter(MeikadeGlobals.masterColor)

                Text {
                    id: message
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: "#ffffff"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 10*Devices.density
                    anchors.rightMargin: 10*Devices.density
                }
            }

            Connections{
                target: Meikade
                onCurrentLanguageChanged: header.initTranslations()
            }

            function initTranslations(){
                backup_txt.text  = qsTr("Create New Backup")
                message.text     = qsTr("AVAILABLE BACKUPS")
                title.text       = qsTr("Create and restore backup from your notes and bookmarks.")
            }

            Component.onCompleted: {
                initTranslations()
            }
        }

        focus: true
        highlight: Rectangle { color: "#3B97EC"; radius: 3; smooth: true }
        currentIndex: -1

        function refresh() {
            model.clear()

            var backups = Meikade.findBackups()
            for( var i=0; i<backups.length; i++ )
                model.append({"path": backups[i]})

            focus = true
        }

        Component.onCompleted: refresh()
    }

    ScrollBar {
        scrollArea: prefrences; height: prefrences.height
        anchors.right: prefrences.right; anchors.top: prefrences.top; color: "#333333"
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }

    Popup {
        id: removePopup

        Material.theme: Material.Dark

        property string filePath

        x: parent.width/2 - width/2
        y: parent.height/2 - height/2
        modal: true
        focus: true

        onVisibleChanged: {
            if(visible) {
                BackHandler.pushHandler(removePopup, function(){removePopup.visible = false})
            } else {
                BackHandler.removeHandler(removePopup)
            }
        }

        ColumnLayout {

            Label {
                Layout.preferredWidth: 200*Devices.density
                color: "#ffffff"
                font.pixelSize: 14*Devices.fontDensity
                horizontalAlignment: Label.AlignHCenter
                text: qsTr("Are you sure?")
            }

            Button {
                text: qsTr("Delete")
                onClicked: {
                    if(removePopup.filePath != "")
                        Meikade.removeFile(removePopup.filePath)

                    removePopup.close()
                    prefrences.refresh()
                }

                textColor: "#F44336"
                highlightColor: Qt.lighter("#313131")
                fontSize: 11*Devices.fontDensity
                height: 40*Devices.density

                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }
        }
    }
}
