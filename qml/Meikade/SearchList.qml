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
import Meikade 1.0
import QtQuick.Controls 2.0 as QtControls
import QtQuick.Controls.Material 2.0
import AsemanTools.Awesome 1.0

Rectangle {
    id: search_list
    width: 100
    height: 62
    color: Meikade.nightTheme? "#222222" : "#ffffff"

    property alias keyword: tmodel.keyword
    property alias poetId: tmodel.poet
    property alias poetCombo: poets_combo

    signal itemSelected( int poem_id, int vid )

    Timer {
        id: search_timer
        interval: 300
        repeat: false
        onTriggered: view_list.find(search_list.keyword)
    }

    ThreadedSearchModel {
        id: tmodel
        database: Database
        onFinishedChanged: if(finished && count==0) nfound_txt.visible = true
        onCountChanged: if(count != 0) nfound_txt.visible = false
    }

    Item {
        id: viewFrame
        anchors.top: advanced.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Text {
            id: nfound_txt
            y: 40*Devices.density
            anchors.horizontalCenter: parent.horizontalCenter
            color: Meikade.nightTheme? "#ffffff" : "#333333"
            font.pixelSize: 11*globalFontDensity*Devices.fontDensity
            font.family: AsemanApp.globalFont.family
            text: qsTr("Not found")
            visible: false
        }

        AsemanListView {
            id: view_list
            anchors.fill: parent
            highlightMoveDuration: 250
            bottomMargin: View.navigationBarHeight

            property bool atEnd: atYEnd
            onAtEndChanged: if(atEnd && count != 0) tmodel.more()

            model: tmodel
            delegate: Rectangle {
                id: item
                width: view_list.width
                height: poem.height + txt_frame.height
                color: press? "#11000000" : "#00000000"

                property alias press: marea.pressed

                PoemItem {
                    id: poem
                    width: parent.width
                    color: "#00000000"
                    textColor: Meikade.nightTheme? "#ffffff" : "#333333"
                    vid: model.vorder
                    pid: model.poem
                    font.pixelSize: Devices.isMobile? 9*globalFontDensity*Devices.fontDensity : 10*globalFontDensity*Devices.fontDensity
                }

                Rectangle {
                    id: txt_frame
                    height: poet.height
                    width: parent.width
                    anchors.bottom: parent.bottom
                    color: "#EC4334"

                    Text {
                        id: poet
                        anchors.bottom: parent.bottom
                        x: View.defaultLayout? parent.width - width - 8*Devices.density : 8*Devices.density
                        font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                        font.family: AsemanApp.globalFont.family
                        color: "#ffffff"

                        Component.onCompleted: {
                            var cat = Database.poemCat(poem.pid)
                            var str
                            str = Database.catName(cat) + ", "
                            str += Database.poemName(poem.pid)

                            var poet
                            var book
                            while( cat ) {
                                book = poet
                                poet = cat
                                cat = Database.parentOf(cat)
                            }

                            str = Database.catName(poet) + ", " + Database.catName(book) + ", " + str
                            text = str
                        }
                    }
                }

                MouseArea{
                    id: marea
                    anchors.fill: parent
                    onClicked: {
                        search_list.itemSelected(poem.pid,poem.masterVid)
                    }
                }
            }

            footer: Item {
                width: view_list.width
                height: 42*Devices.density

                Indicator {
                    anchors.centerIn: parent
                    modern: true
                    light: false
                    indicatorSize: 22*Devices.density

                    property bool active: tmodel.refreshing
                    onActiveChanged: {
                        if(active)
                            start()
                        else
                            stop()
                    }
                }
            }
        }

        ScrollBar {
            scrollArea: view_list; height: view_list.height
            anchors.right: view_list.right; anchors.top: view_list.top
            LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
        }

        GoUpButton { list: view_list }
    }

    Rectangle {
        id: advanced
        anchors.top: parent.top
        width: parent.width
        height: 40*Devices.density
        color: "#fcfcfc"

        QtControls.ComboBox {
            id: poets_combo
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 8*Devices.density
            anchors.leftMargin: 8*Devices.density
            currentIndex: 0
            textRole: "text"
            model: ListModel{
                id: poets_model
            }
            onCurrentIndexChanged: txt.refresh()
            popup.onVisibleChanged: {
                if(popup.visible)
                    BackHandler.pushHandler(poets_combo, function(){popup.visible = false})
                else
                    BackHandler.removeHandler(poets_combo)
            }

            delegate: Rectangle {
                width: poets_combo.width
                height: 50*Devices.density
                color: marea.pressed? "#22000000" : "#00000000"

                Text {
                    anchors.centerIn: parent
                    text: model.text
                    font.family: AsemanApp.globalFont.family
                    font.pixelSize: 10*Devices.fontDensity
                    opacity: enabled ? 1.0 : 0.3
                    font.bold: poets_combo.currentIndex == index
                    color: "#333333"
                }

                MouseArea {
                    id: marea
                    anchors.fill: parent
                    onClicked: {
                        poets_combo.currentIndex = index
                        poets_combo.popup.close()
                    }
                }
            }

            Material.background: "transparent"
            Material.elevation: 0

            Connections {
                target: Database
                onPoetsChanged: refresh()
                onInitializeFinished: refresh()
                Component.onCompleted: refresh()

                function refresh(){
                    poets_combo.model.clear()
                    poets_model.append({"text": qsTr("All Poets"), "pid": -1})

                    var poets = Database.poets()
                    for(var i=0; i<poets.length; i++) {
                        var pid = poets[i]
                        poets_model.append({"text": Database.catName(pid), "pid": pid})
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: poets_combo
            color: advanced.color
            z: 100

            Text {
                id: sscope_lbl
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: View.defaultLayout? undefined : parent.right
                anchors.left: View.defaultLayout? parent.left : undefined
                anchors.leftMargin: 8*Devices.density
                anchors.rightMargin: 8*Devices.density
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                verticalAlignment: Text.AlignVCenter
//                font.underline: true
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
                color: "#5d5d5d"
                text: qsTr("Search in:")
            }

            Text {
                anchors.right: View.defaultLayout? parent.right : sscope_lbl.left
                anchors.left: View.defaultLayout? sscope_lbl.right : parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 8*Devices.density
                anchors.rightMargin: 8*Devices.density
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
                color: "#5d5d5d"
                text: poets_combo.currentText
            }
        }
    }

    TitleBarShadow {
        anchors.top: advanced.bottom
        width: advanced.width
        height: 1*Devices.density
        opacity: 0.5
    }
}
