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
    id: category
    width: 100
    height: 62

    property int catId: -1
    property alias itemsSpacing: category_list.spacing
    property real topMargin: itemsSpacing
    property alias header: category_list.header
    property alias footer: category_list.footer

    onCatIdChanged: category_list.refresh()

    signal categorySelected( int cid, variant rect )
    signal poemSelected( int pid, variant rect )

    ListView {
        id: category_list
        anchors.fill: parent
        bottomMargin: View.navigationBarHeight + spacing
        maximumFlickVelocity: View.flickVelocity
        clip: true
        spacing: 8*Devices.density
        topMargin: category.topMargin
        boundsBehavior: Flickable.StopAtBounds
        rebound: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 0
            }
        }

        onVerticalVelocityChanged: {
            if(catId != 0)
                return
            if((verticalVelocity>4 && !atYBeginning) || atYEnd)
                materialDesignButton.hide()
            else
            if((verticalVelocity<-4 && !atYEnd) || atYBeginning)
                materialDesignButton.show()
        }

        model: ListModel {}
        delegate: Rectangle {
            id: item
            x: category_list.spacing
            width: category_list.width - 2*x
            height: 55*Devices.density
            border.width: 1*Devices.density
            border.color: Meikade.nightTheme? "#333333" : "#cccccc"
            color: marea.pressed? (Meikade.nightTheme? "#1D2124" : "#CFDAFF") : (Meikade.nightTheme? "#111111" : "#ffffff")

            CategoryItem {
                anchors.fill: parent
                cid: identifier
                root: category.catId == 0
            }

            Image {
                id: go_img
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 8*Devices.density
                height: 20*Devices.density
                width: height
                sourceSize: Qt.size(width,height)
                fillMode: Image.PreserveAspectFit
                source: "icons/go.png"
                opacity: 0.4
            }

            MouseArea{
                id: marea
                anchors.fill: parent
                onClicked: {
                    materialDesignButton.hide()
                    var childs = Database.childsOf(identifier)

                    var map = item.mapToItem(category, 0, 0)
                    var rect = Qt.rect(map.x, map.y, item.width, item.height)
                    if( childs.length === 0 && !item.hafezOmen )
                        category.poemSelected(identifier, rect)
                    else
                        category.categorySelected(identifier, rect)
                }
            }
        }

        function refresh() {
            model.clear()

            var list = category.catId==0? Database.poets() : Database.childsOf(category.catId)
            for( var i=0; i<list.length; i++ ) {
                model.append({"identifier":list[i]})
            }

            focus = true
        }
    }

    ScrollBar {
        scrollArea: category_list; height: category_list.height-topMargin-View.navigationBarHeight
        anchors.left: category_list.left; anchors.top: category_list.top
        anchors.topMargin: topMargin; color: Meikade.nightTheme? "#ffffff" : "#111111"
    }

    Text {
        anchors.centerIn: parent
        font.pixelSize: 9*Devices.fontDensity
        text: qsTr("This is a problem to loading poets.\nPlease contact us:\ncontact@aseman.org")
        visible: category_list.count == 0
    }
}
