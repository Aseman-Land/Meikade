import QtQuick 2.12
import globals 1.0
import components 1.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Controls.Beta 3.0
import AsemanQml.Controls 2.0

MPage {
    id: page
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias forgetBtn: columnLayout.forgetBtn
    property alias signupBtn: columnLayout.signupBtn
    property alias passTxt: columnLayout.passTxt
    property alias cancelBtn: cancelBtn
    property alias headerItem: headerItem
    property alias sendBtn: columnLayout.sendBtn
    property alias userTxt: columnLayout.userTxt
    property alias introMode: columnLayout.introMode
    property alias loginLabel: columnLayout.loginLabel
    property alias skipLoginBtn: columnLayout.skipLoginBtn
    property alias backgroudMouseArea: backgroudMouseArea

    AsemanFlickable {
        id: flickable
        anchors.fill: parent
        contentWidth: scene.width
        contentHeight: scene.height
        flickDeceleration: Flickable.VerticalFlick

        Item {
            id: scene
            width: flickable.width
            height: Math.max(flickable.height, columnLayout.height)

            MouseArea {
                id: backgroudMouseArea
                anchors.fill: parent
            }

            LoginColumnForm {
                id: columnLayout
                width: Math.min(parent.width - 40 * Devices.density, 350*Devices.density)
                anchors.centerIn: parent
            }
        }
    }

    header: MHeader {
        id: headerItem
        title: qsTr("Authenticating") + Translations.refresher
        visible: !introMode

        HeaderBackButton {
            id: cancelBtn
        }
    }
}
