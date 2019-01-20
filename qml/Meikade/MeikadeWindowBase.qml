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
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0

Rectangle {
    id: smain
    focus: true

    property alias bottomPanel: bottom_panel
    property alias messageDialog: message_dialog

    property color subMessageBackground: "#66ffffff"
    property bool subMessageBlur: true

    property variant mainFrame
    property SubMessage subMessage

    property real panelWidth: width

    BottomPanel {
        id: bottom_panel
        z: 10
    }

    MessageDialog {
        id: message_dialog
        anchors.fill: parent
        z: 10
    }

    Tooltip {
        id: tool_tip
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 32*Devices.density + View.navigationBarHeight
        z: 11
    }

    function showTooltip( text ) {
        View.root.showTooltip(text)
    }

    function showSubMessage( item_component ){
        var item = item_component.createObject(View.root);
        var msg = sub_msg_component.createObject(View.root);
        msg.source = mainFrame
        msg.item = item
        subMessage = msg
        return item
    }

    function hideSubMessage(){
        if( !subMessage )
            return

        subMessage.hide()
    }

    function showBottomPanel( component, fullWidth ){
        hideBottomPanel()
        bottom_panel.anchors.rightMargin = fullWidth? 0 : panelWidth

        var item = component.createObject(bottom_panel);
        bottom_panel.item = item
        return item
    }

    function hideBottomPanel() {
        if( bottom_panel.item )
            bottom_panel.hide()
    }

    Component {
        id: sub_msg_component

        SubMessage {
            id: sub_msg
            backgroundColor: subMessageBackground
            blurBack: subMessageBlur
        }
    }

    Component.onCompleted: {
        View.root = smain
    }
}
