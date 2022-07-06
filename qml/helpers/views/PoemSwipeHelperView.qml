import QtQuick 2.0
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import AsemanQml.Controls 2.0
import QtQuick.Layouts 1.3
import components 1.0

Item {
    id: form
    height: 470 * Devices.density

    property alias okBtn: okBtn

    Rectangle {
        anchors.fill: parent
        color: helper.color
    }

    ColumnLayout {
        id: sceneColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4 * Devices.density

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: 15 * Devices.density
            Layout.rightMargin: 15 * Devices.density
            font.pixelSize: 11 * Devices.fontDensity
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: qsTr("Help") + Translations.refresher
        }

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: 15 * Devices.density
            Layout.rightMargin: 15 * Devices.density
            Layout.bottomMargin: 15 * Devices.density
            font.pixelSize: 8 * Devices.fontDensity
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: qsTr("To go to the next/previous poem, hold center of the screen and swipe it to the left or right.") + Translations.refresher
        }

        PoemSwipeHelperAnimation {
            id: helper
            Layout.fillWidth: true
            Layout.preferredHeight: 300 * Devices.density
            transform: Scale {
                origin.x: helper.width/2
                origin.y: helper.height/2
                yScale: 1
                xScale: form.LayoutMirroring.enabled? -1 : 1
            }
        }

        Button {
            id: okBtn
            font.pixelSize: 9 * Devices.fontDensity
            Layout.fillWidth: true
            Layout.leftMargin: 15 * Devices.density
            Layout.rightMargin: 15 * Devices.density
            text: qsTr("I Undrestand") + Translations.refresher
            highlighted: true
        }
    }
}
