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
import AsemanTools 1.0

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

    Item {
        id: msg_item
        height: 54*Devices.density
        visible: false

        property string filePath

        Text {
            id: delete_warn
            font.pixelSize: 17*globalFontDensity*Devices.fontDensity
            font.family: AsemanApp.globalFont.family
            anchors.margins: 10*Devices.density
            anchors.left: parent.left
            anchors.right: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#ffffff"
        }

        Button {
            id: yes_button
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: no_button.left
            anchors.rightMargin: 5*Devices.density
            anchors.margins: 10*Devices.density
            width: parent.width/4 - 5*Devices.density
            normalColor: "#aaC80000"
            onClicked: {
                if( msg_item.filePath != "" )
                    Meikade.removeFile(msg_item.filePath)

                hideRollerDialog()
                prefrences.refresh()
            }
        }

        Button {
            id: no_button
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 5*Devices.density
            anchors.margins: 10*Devices.density
            width: parent.width/4 - 5*Devices.density
            normalColor: "#66ffffff"
            onClicked: {
                hideRollerDialog()
            }
        }
    }

    ListView {
        id: prefrences
        anchors.fill: parent
        anchors.topMargin: 4*Devices.density
        anchors.bottomMargin: 4*Devices.density
        highlightMoveDuration: 250
        maximumFlickVelocity: View.flickVelocity
        boundsBehavior: Flickable.StopAtBounds
        rebound: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 0
            }
        }
        clip: true

        model: ListModel {}
        delegate: Rectangle {
            id: item
            width: prefrences.width
            height: txt.height + 30*Devices.density
            color: press? "#880d80ec" : "#00000000"

            property string file: path
            property alias press: marea.pressed

            onPressChanged: hideRollerDialog()

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
                onClicked: {
                    msg_item.filePath = item.file
                    showRollerDialog( item.mapToItem(main,0,0).y, item.mapToItem(main,0,item.height).y, msg_item )
                }

                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 15*globalFontDensity*Devices.fontDensity
                    font.family: awesome_font.name
                    color: "#99ff0000"
                    text: ""
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

            Rectangle {
                id: header_back
                width: header.width
                height: 60*Devices.density
                anchors.top: title.bottom
                color: press? "#880d80ec" : "#00000000"

                property alias press: hmarea.pressed

                Text{
                    id: backup_txt
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 30*Devices.density
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
                anchors.margins: 10*Devices.density
                anchors.bottomMargin: 0*Devices.density
                height: 2*Devices.density
                color: "#ffffff"

                Text {
                    id: message
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: splitter.color
                    anchors.bottom: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottomMargin: -5*Devices.density
                }
            }

            Connections{
                target: Meikade
                onCurrentLanguageChanged: header.initTranslations()
            }

            function initTranslations(){
                backup_txt.text  = qsTr("Create new Backup")
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
    }

    Connections{
        target: Meikade
        onCurrentLanguageChanged: initTranslations()
    }

    function initTranslations(){
        delete_warn.text = qsTr("Are you sure?")
        yes_button.text  = qsTr("Delete")
        no_button.text   = qsTr("Cancel")
    }

    Component.onCompleted: {
        initTranslations()
    }
}
