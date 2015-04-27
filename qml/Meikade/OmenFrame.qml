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
    id: omen_frame
    width: 100
    height: 62

    property int catId: -1
    property int cellulSize: 10*Devices.density

    property int startId: 2130
    property int idDomain: 494

    signal itemSelected( int pid )

    onWidthChanged: refresh()
    onHeightChanged: refresh()
    onCellulSizeChanged: refresh()

    HashObject {
        id: hash
    }

    MouseArea {
        id: marea
        anchors.fill: parent
        onReleased: {
            var res = omen_frame.locationId(px,py)
            omen_frame.itemSelected(res)
        }
        onPressed: {
            px = mouseX
            py = mouseY
        }
        onMouseXChanged: if( px > 0 && px < marea.width  ) px = (mouseX+px)/2
        onMouseYChanged: if( py > 0 && py < marea.height ) py = (mouseY+py)/2

        property real px: 0
        property real py: 0
    }

    function refresh(){
        refresh_timer.restart()
    }

    function refresh_prev(){
        hash.clear()

        var length = Math.floor(omen_frame.width/omen_frame.cellulSize+1)*Math.floor(omen_frame.height/omen_frame.cellulSize+1)
        for( var i=0; i<length; i++ ) {
            var random = Math.random(Meikade.mSecsSinceEpoch()%100000)
            var id = Math.floor(omen_frame.startId + random*(omen_frame.idDomain+1))
            hash.insert( i, id )
        }
    }

    function locationId( x, y ){
        var id = Math.floor(omen_frame.width/omen_frame.cellulSize+1)*Math.floor(y/omen_frame.cellulSize-1) *
                 (Math.floor(y/omen_frame.cellulSize-1)>=0) + Math.floor(x/omen_frame.cellulSize)

        return hash.value(id)
    }

    Timer {
        id: refresh_timer
        interval: 400
        repeat: false
        onTriggered: refresh_prev()
    }

    Component.onCompleted: omen_frame.refresh()
}
