import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import globals 1.0
import components 1.0
import "privates"

MPage {
    id: homeForm
    width: Constants.width
    height: Constants.height
    property alias prevBtn: prevBtn
    property alias nextBtn: nextBtn
    property alias doneForm: doneForm
//    property alias setupHomeForm: setupHomeForm
    property alias welcomForm: welcomForm
    property alias loginForm: loginForm
    property alias setupThemeForm: setupThemeForm

    property alias list: list

    Item {
        id: list
        anchors.fill: parent
//        interactive: false

        property int currentIndex: 0
        property int count: 4

        IntroWelcomForm {
            id: welcomForm
            anchors.fill: parent
            visible: list.currentIndex == 0
        }
        Item {
            id: loginForm
            anchors.fill: parent
            visible: list.currentIndex == 1
        }
        IntroSetupTheme {
            id: setupThemeForm
            anchors.fill: parent
            visible: list.currentIndex == 2
        }
        IntroDoneForm {
            id: doneForm
            anchors.fill: parent
            visible: list.currentIndex == 3
        }
    }

    MPageIndicator {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 15 * Devices.density + Devices.navigationBarHeight
        count: list.count
        currentIndex: list.currentIndex
    }

    MButton {
        id: nextBtn
        width: 100 * Devices.density
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Devices.navigationBarHeight
        anchors.right: parent.right
        flat: true
        highlighted: true
        text: qsTr("Skip") + Translations.refresher
        visible: list.currentIndex < list.count - 1
        onClicked: AsemanGlobals.introDone = true
    }

    MButton {
        id: prevBtn
        width: 100 * Devices.density
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Devices.navigationBarHeight
        anchors.left: parent.left
        flat: true
        highlighted: true
        text: qsTr("Prev") + Translations.refresher
        visible: list.currentIndex > 0
        onClicked: list.currentIndex--
    }
}

