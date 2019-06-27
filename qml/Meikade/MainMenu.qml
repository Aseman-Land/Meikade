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
import QtQuick.Controls 2.1
import AsemanQml.Base 2.0
import AsemanQml.Awesome 2.0
import AsemanQml.Controls 2.0
import QtQuick.Layouts 1.3
import "globals"

Item {
    id: mmenu
    width: 100
    height: 62
    clip: true

    signal selected( string fileName )

    AsemanListView {
        id: list
        anchors.fill: parent
        model: ListModel{}
        orientation: Qt.Vertical
        header: Item {
            width: list.width
            height: menu_cover.height
            clip: true

            Image {
                id: menu_cover
                width: list.width + 4*Devices.density
                anchors.horizontalCenter: parent.horizontalCenter
                height: width*9/16
                fillMode: Image.PreserveAspectCrop
                source: "icons/menu-back.jpg"
                sourceSize: Qt.size(width*2,height*2)
            }

            CachedImage {
                id: menu_adv
                anchors.fill: menu_cover
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                sourceSize: menu_cover.sourceSize
                clip: true

                property string advertiseLink

                Component.onCompleted: {
                    AsemanServices.meikade.getAdvertise(function(res, error){
                        menu_adv.source = res.image
                        menu_adv.advertiseLink = res.link
                    })
                }
            }

            MouseArea {
                anchors.fill: parent
                visible: menu_adv.advertiseLink.trim().length != 0
                onClicked: Qt.openUrlExternally(menu_adv.advertiseLink)
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
                color: MeikadeGlobals.foregroundColor
                opacity: 0.2
                visible: section != "A"
            }
        }

        delegate: Item {
            id: item
            width: list.width
            height: 36*Devices.density

            property alias press: marea.pressed

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 15*Devices.density
                layoutDirection: View.layoutDirection
                spacing: 25*Devices.density

                Text {
                    font.pixelSize: 14*globalFontDensity*Devices.fontDensity
                    font.family: Awesome.family
                    color: MeikadeGlobals.foregroundColor
                    opacity: 0.7
                    horizontalAlignment: Text.AlignHCenter
                    text: icon
                }

                Text {
                    Layout.fillWidth: true
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: MeikadeGlobals.foregroundColor
                    horizontalAlignment: View.defaultLayout? Qt.AlignLeft : Qt.AlignRight
                    text: name
                }
            }

            ItemDelegate {
                id: marea
                anchors.fill: parent
                onClicked: {
                    AsemanServices.meikade.pushAction( ("Menu Action: %1").arg(fileName), null )
                    mmenu.selected(fileName)
                }
            }
        }

        function refresh() {
            model.clear()
            model.append({"name":qsTr("Meikade")           , "icon": Awesome.fa_home, "fileName":""                      , "type": "A"})
            model.append({"name":qsTr("Search")            , "icon": Awesome.fa_search, "fileName":"SearchBar.qml"            , "type": "A"})
            model.append({"name":qsTr("Bookmarks")         , "icon": Awesome.fa_bookmark_o, "fileName":"BookmarksPoets.qml"         , "type": "A"})
            model.append({"name":qsTr("Store")             , "icon": Awesome.fa_shopping_cart, "fileName":"StorePage.qml" , "type": "A"})
//            model.append({"name":qsTr("Notes")             , "icon": Awesome.fa_sticky_note, "fileName":"Notes.qml"             , "type": "A"})
            model.append({"name":qsTr("Configure")         , "icon": Awesome.fa_cog, "fileName":"Configure.qml"         , "type": "C"})
            model.append({"name":qsTr("OpenSource Projecs"), "icon": Awesome.fa_code_fork, "fileName":"OpenSourceProjects.qml", "type": "C"})
            model.append({"name":qsTr("Contact")           , "icon": Awesome.fa_mail_reply, "fileName":"Contact.qml"            , "type": "C"})
            model.append({"name":qsTr("About")             , "icon": Awesome.fa_info_circle, "fileName":"About.qml"             , "type": "C"})
//            model.append({"name":qsTr("About Nile Group")  , "icon": Awesome.fa_info_circle, "fileName":"AboutNileTeam.qml"     , "type": "C"})
            model.append({"name":qsTr("About Aseman")  , "icon": Awesome.fa_info_circle, "fileName":"AboutAseman.qml"     , "type": "C"})
        }
    }

    Connections{
        target: MeikadeGlobals.translator
        onLocaleNameChanged: initTranslations()
    }

    function initTranslations(){
        list.refresh()
    }

    Component.onCompleted: {
        initTranslations()
    }

    ScrollBar {
        scrollArea: list; height: list.height; anchors.top: list.top
        anchors.right: list.right; color: "#333333"
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }
}
