import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Models 2.0
import QtQuick.Layouts 1.3
import globals 1.0
import components 1.0
import models 1.0
import "privates"

DrawerFrame {
    id: dis
    width: Constants.width
    height: Constants.height
    headerLabel.text: qsTr("Smart Search") + Translations.refresher

    property alias textLabel: textLabel

    scene.height: Math.max(flickable.height, sceneColumn.height)

    ColumnLayout {
        id: sceneColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15 * Devices.density
        spacing: 4 * Devices.density

        MLabel {
            id: textLabel
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Some about text") + Translations.refresher
        }
    }
}

