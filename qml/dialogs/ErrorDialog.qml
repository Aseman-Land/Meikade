import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import "views"

ErrorDialogView {
    width: Math.min(300*Devices.density, Viewport.viewport.width*0.8)

    property variant buttons
    property string title
    property string body

    titleLabel.text: title
    bodyLabel.text: body
    repeater.model: buttons? buttons : [ qsTr("Ok") + Translations.refresher ]

    onItemClicked: if (!buttons && index == 0) Viewport.viewport.closeLast()
}


