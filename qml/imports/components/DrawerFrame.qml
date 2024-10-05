import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
import QtQuick.Layouts 1.3
import globals 1.0

Item {
    width: Constants.width
    height: Constants.height

    default property alias sceneData: scene.data
    property alias cancelBtn: cancelBtn
    property alias headerLabel: headerLabel
    property alias scene: scene
    property alias flickable: flickable
    property alias headerItem: headerItem


    Rectangle {
        anchors.fill: parent
        color: Colors.background
        opacity: 0.5
    }

    AsemanFlickable {
        id: flickable
        anchors.top: headerItem.visible? headerItem.bottom : parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height
        clip: true

        EscapeItem {
            id: scene
            width: flickable.width
            height: flickable.height
        }
    }

    Item {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: Devices.standardTitleBarHeight

        Separator {}

        MLabel {
            id: headerLabel
            anchors.centerIn: parent
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Frame") + Translations.refresher
        }

        HeaderBackButton {
            id: cancelBtn
            y: 0
            iosPopup: true
            color: Colors.foreground
        }
    }
}
