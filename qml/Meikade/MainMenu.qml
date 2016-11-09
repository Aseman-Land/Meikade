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
import AsemanTools.Awesome 1.0
import QtQuick.Layouts 1.3

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
                source: "icons/menu-back.jpg"
                sourceSize: Qt.size(width*2,height*2)
            }

            Image {
                id: menu_adv
                anchors.fill: menu_cover
                fillMode: Image.PreserveAspectFit
                source: networkFeatures.advertisePhoto
                asynchronous: true
                sourceSize: menu_cover.sourceSize
                clip: true

                property Item advItem
                property string advertiseQml: networkFeatures.advertiseQml
                onAdvertiseQmlChanged: {
                    if(advItem) {
                        advItem.visible = 0
                        Tools.deleteItemDelay(10, advItem)
                        advItem = null
                    }
                    if(advertiseQml.length == 0)
                        return

                    advItem = Meikade.createObject(advertiseQml)
                    advItem.parent = parent
                }
            }

            MouseArea {
                anchors.fill: parent
                visible: networkFeatures.advertiseLink.trim().length != 0
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

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 15*Devices.density
                layoutDirection: View.layoutDirection
                spacing: 15*Devices.density

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 14*globalFontDensity*Devices.fontDensity
                    font.family: Awesome.family
                    color: "#777777"
                    horizontalAlignment: Text.AlignHCenter
                    text: icon
                }

                Text {
                    Layout.fillWidth: true

                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: "#444444"
                    horizontalAlignment: View.layoutDirection==Qt.LeftToRight? Qt.AlignLeft : Qt.AlignRight
                    text: name
                }
            }

            MouseArea {
                id: marea
                anchors.fill: parent
                onClicked: {
                    networkFeatures.pushAction( ("Menu Action: %1").arg(fileName) )
                    mmenu.selected(fileName)
                }
            }
        }

        Component.onCompleted: {
            model.append({"name":qsTr("Meikade")           , "icon": Awesome.fa_home, "fileName":""                      , "type": "A"})
            model.append({"name":qsTr("Search")            , "icon": Awesome.fa_search, "fileName":"SearchBar.qml"            , "type": "A"})
            model.append({"name":qsTr("Bookmarks")         , "icon": Awesome.fa_bookmark_o, "fileName":"Bookmarks.qml"         , "type": "A"})
            model.append({"name":qsTr("Store")             , "icon": Awesome.fa_shopping_cart, "fileName":"XmlDownloaderPage.qml" , "type": "A"})
//            model.append({"name":qsTr("Notes")             , "icon": Awesome.fa_sticky_note, "fileName":"Notes.qml"             , "type": "A"})
            model.append({"name":qsTr("Configure")         , "icon": Awesome.fa_cog, "fileName":"Configure.qml"         , "type": "C"})
            model.append({"name":qsTr("OpenSource Projecs"), "icon": Awesome.fa_code_fork, "fileName":"OpenSourceProjects.qml", "type": "C"})
            model.append({"name":qsTr("About")             , "icon": Awesome.fa_info_circle, "fileName":"About.qml"             , "type": "C"})
            model.append({"name":qsTr("About Nile Group")  , "icon": Awesome.fa_info_circle, "fileName":"AboutNileTeam.qml"     , "type": "C"})
        }
    }

    ScrollBar {
        scrollArea: list; height: list.height; anchors.top: list.top
        anchors.left: list.left; color: "#333333"
    }
}
