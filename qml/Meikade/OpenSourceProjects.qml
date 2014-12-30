/*
    Copyright (C) 2014 Aseman Labs
    http://labs.aseman.org

    Kaqaz is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Kaqaz is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import AsemanTools 1.0

Rectangle {
    width: 100
    height: 62
    color: "#ffffff"

    Rectangle {
        anchors.fill: title
        anchors.topMargin: -View.statusBarHeight
        color: "#7BCF6A"
    }

    Header {
        id: title
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: View.statusBarHeight
        anchors.right: parent.right
        titleFont.pixelSize: 13*Devices.fontDensity
        light: true
    }

    Text {
        id: desc_txt
        anchors.left: parent.left
        anchors.top: title.bottom
        anchors.right: parent.right
        anchors.margins: 8*Devices.density
        font.family: AsemanApp.globalFontFamily
        font.pixelSize: 9*Devices.fontDensity
        color: "#333333"
        text: qsTr("List of other opensource projects used in Meikade.")
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }

    ListView {
        id: preference_list
        anchors.top: desc_txt.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 20*Devices.density
        highlightMoveDuration: 250
        bottomMargin: View.navigationBarHeight
        clip: true
        focus: true

        model: ListModel {}
        delegate: Item {
            id: item
            anchors.left: parent.left
            anchors.right: parent.right
            height: column.height + 20*Devices.density

            Column {
                id: column
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 10*Devices.density

                Item {
                    id: title_item
                    height: title_txt.height
                    width: column.width

                    Text {
                        id: title_txt
                        font.pixelSize: 14*Devices.fontDensity
                        font.family: AsemanApp.globalFontFamily
                        anchors.left: parent.left
                        color: "#333333"
                        text: title
                    }

                    Text {
                        id: license_txt
                        font.pixelSize: 10*Devices.fontDensity
                        font.family: AsemanApp.globalFontFamily
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        color: "#666666"
                        text: license
                    }
                }

                Text {
                    id: description_txt
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFontFamily
                    anchors.left: parent.left
                    anchors.right: parent.right
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "#555555"
                    text: description
                }

                Text {
                    id: link_txt
                    font.pixelSize: 9*Devices.fontDensity
                    font.family: AsemanApp.globalFontFamily
                    color: "#0d80ec"
                    text: link

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally(link_txt.text)
                    }
                }
            }
        }

        Component.onCompleted: {
            model.clear()

            model.append({"title": "Droid fonts", "license": "Apache License v2", "link": "https://www.google.com/fonts/specimen/Droid+Sans", "description": "Droid Sans is a humanist sans serif typeface designed by Steve Matteson, Type Director of Ascender Corp."})
            model.append({"title": "Ganjoor", "license": "GNU GPL v2", "link": "http://ganjoor.net", "description": "Persian poetry web site called ganjoor which includes a .NET based Windows client and a SQLite copy of site database"})
            model.append({"title": "Qt Framework " + Tools.qtVersion(), "license": "GNU GPL v3", "link": "http://qt.io", "description": "Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language."})
            model.append({"title": "QtSingleApplication", "license": "GNU GPL v3", "link": "https://github.com/lycis/QtDropbox/", "description": "The QtSingleApplication component provides support for applications that can be only started once per user."})
            model.append({"title": "Saaghar", "license": "GNU GPL v3", "link": "https://sourceforge.net/projects/saaghar/", "description": "Saaghar is a Persian poetry software written by C++ under Qt framework, it uses ganjoor database as its database. It has tab feature in both its Viewer and its Search page that cause it be suitable for research goals."})
            model.append({"title": "Aseman Qt Tools", "license": "GNU GPL v3", "link": "https://github.com/aseman-labs/aseman-qt-tools", "description": "Some tools, creating for Aseman Qt projects and used on many of Aseman's projects"})
            model.append({"title": "SimpleQtCryptor", "license": "GNU GPL v3", "link": "http://zo0ok.com/techfindings/archives/595", "description": "Simple Qt encryption library and tools."})

            focus = true
        }
    }

    ScrollBar {
        scrollArea: preference_list; height: preference_list.height - View.navigationBarHeight
        width: 6*Devices.density
        anchors.right: preference_list.right; anchors.top: preference_list.top;
        color: "#000000"
    }

    Connections{
        target: Meikade
        onCurrentLanguageChanged: initTranslations()
    }

    function initTranslations(){
        title.text = qsTr("Open Source Projects")
    }

    Component.onCompleted: {
        initTranslations()
    }
}
