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

        ListView {
            id: view_list
            anchors.fill: parent
            highlightMoveDuration: 250
            maximumFlickVelocity: View.flickVelocity
            bottomMargin: View.navigationBarHeight
            boundsBehavior: Flickable.StopAtBounds
            rebound: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 0
                }
            }

            property bool atEnd: atYEnd
            onAtEndChanged: if(atEnd && count != 0) tmodel.more()

            onVerticalVelocityChanged: {
                if(view_list.atYBeginning || view_list.count == 0)
                    ascroll.hide = true
                else
                if((verticalVelocity>4 && !atYBeginning) || atYEnd)
                    ascroll.hide = true
                else
                if((verticalVelocity<-4 && !atYEnd) || atYBeginning)
                    ascroll.hide = false
            }

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
                        x: View.layoutDirection==Qt.LeftToRight? parent.width - width - 8*Devices.density : 8*Devices.density
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

            currentIndex: -1
        }

        ScrollBar {
            scrollArea: view_list; height: view_list.height
            anchors.left: view_list.left; anchors.top: view_list.top
        }
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
            textRole: "text"
            model: ListModel{
                id: poets_model
            }
            onCurrentIndexChanged: txt.refresh()

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
                anchors.right: View.layoutDirection==Qt.LeftToRight? undefined : parent.right
                anchors.left: View.layoutDirection==Qt.LeftToRight? parent.left : undefined
                anchors.leftMargin: 8*Devices.density
                anchors.rightMargin: 8*Devices.density
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                verticalAlignment: Text.AlignVCenter
                font.underline: true
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
                color: "blue"
                text: qsTr("Search in:")
            }

            Text {
                anchors.right: View.layoutDirection==Qt.LeftToRight? parent.right : sscope_lbl.left
                anchors.left: View.layoutDirection==Qt.LeftToRight? sscope_lbl.right : parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 8*Devices.density
                anchors.rightMargin: 8*Devices.density
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: View.layoutDirection==Qt.LeftToRight? Text.AlignLeft : Text.AlignRight
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

    Rectangle {
        id: ascroll

        property bool hide: true

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20*Devices.density
        width: 50*Devices.density
        height: width
        radius: width/2
        color: "#66000000"
        opacity: hide? 0 : 1
        z: hide? -1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 500 }
        }

        Text {
            anchors.centerIn: parent
            font.pixelSize: 25*globalFontDensity*Devices.fontDensity
            font.family: Awesome.family
            color: "white"
            text: Awesome.fa_angle_up
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                view_list.positionViewAtBeginning()
                ascroll.hide = true
            }
        }
    }
}
