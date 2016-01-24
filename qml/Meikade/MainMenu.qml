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
    id: mmenu
    width: 100
    height: 62
    clip: true

    signal selected( string fileName )

    ListView {
        id: list
        anchors.fill: parent
        model: ListModel{}
        orientation: Qt.Vertical
        boundsBehavior: Flickable.StopAtBounds
        rebound: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 0
            }
        }

        header: Item {
            width: list.width
            height: menu_cover.height

            Image {
                id: menu_cover
                width: list.width
                height: width*9/16
                fillMode: Image.PreserveAspectCrop
                source: networkFeatures.advertisePhoto.length!=0? networkFeatures.advertisePhoto : "icons/menu-back.jpg"
                sourceSize: Qt.size(width,width)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally(networkFeatures.advertiseLink)
            }
        }

        section.property: "type"
        section.criteria: ViewSection.FullString
        section.delegate: Item {
            width: list.width
            height: 20*Devices.density

            Rectangle {
                width: parent.width - 20*Devices.density
                height: 1*Devices.density
                anchors.centerIn: parent
                color: "#cccccc"
                visible: section != "A"
            }
        }

        delegate: Rectangle {
            id: item
            width: list.width
            height: 36*Devices.density
            color: press? "#880d80ec" : "#00000000"

            property alias press: marea.pressed

            Text {
                id: txt
                anchors.left: parent.left
                anchors.right: item_rect.left
                anchors.margins: 20*Devices.density
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#444444"
                horizontalAlignment: Text.AlignRight
                text: name
            }

            Image {
                id: item_rect
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10*Devices.density
                height: width
                width: 24*Devices.density
                source: icon
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(width, height)
                opacity: 0.6
            }

            MouseArea {
                id: marea
                anchors.fill: parent
                onClicked: {
                    networkFeatures.pushAction( ("Menu Action: %1").arg(fileName) )
                    mmenu.selected(fileName)

                    if(!search_bar.hide)
                        main.mainTitle = ""
                    else
                        main.mainTitle = name
                }
            }
        }

        Component.onCompleted: {
            model.append({"name":qsTr("Meikade")           , "icon": "icons/menu-home.png"      , "fileName":""                      , "type": "A"})
            model.append({"name":qsTr("Search")            , "icon": "icons/menu-search.png"    , "fileName":"cmd:search"            , "type": "A"})
            model.append({"name":qsTr("Bookmarks")         , "icon": "icons/menu-bookmark.png"  , "fileName":"Bookmarks.qml"         , "type": "A"})
            model.append({"name":qsTr("Store")             , "icon": "icons/shop.png"           , "fileName":"XmlDownloaderPage.qml" , "type": "A"})
//            model.append({"name":qsTr("Notes")             , "icon": ""                         , "fileName":"Notes.qml"             , "type": "A"})
            model.append({"name":qsTr("Configure")         , "icon": "icons/menu-configure.png" , "fileName":"Configure.qml"         , "type": "C"})
            model.append({"name":qsTr("OpenSource Projecs"), "icon": "icons/menu-opensource.png", "fileName":"OpenSourceProjects.qml", "type": "C"})
            model.append({"name":qsTr("About")             , "icon": "icons/menu-about.png"     , "fileName":"About.qml"             , "type": "C"})
            model.append({"name":qsTr("About Nile Group")  , "icon": "icons/menu-about.png"     , "fileName":"AboutNileTeam.qml"     , "type": "C"})
        }
    }

    ScrollBar {
        scrollArea: list; height: list.height; anchors.top: list.top
        anchors.left: list.left; color: "#333333"
    }
}
