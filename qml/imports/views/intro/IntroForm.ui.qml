import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import micros 1.0

Page {
    id: homeForm
    width: Constants.width
    height: Constants.height
    property alias prevBtn: prevBtn
    property alias nextBtn: nextBtn
    property alias doneForm: doneForm
    property alias setupOfflinesForm: setupOfflinesForm
    property alias setupHomeForm: setupHomeForm
    property alias welcomForm: welcomForm
    property alias setupThemeForm: setupThemeForm

    property alias list: list

    SwipeView {
        id: list
        anchors.fill: parent
        interactive: false

        IntroWelcomForm {
            id: welcomForm
        }
        IntroSetupHome {
            id: setupHomeForm
        }
        IntroSetupOfflines {
            id: setupOfflinesForm
        }
        IntroSetupTheme {
            id: setupThemeForm
        }
        IntroDoneForm {
            id: doneForm
        }
    }

    PageIndicator {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 15 * Devices.density + Devices.navigationBarHeight
        count: list.count
        currentIndex: list.currentIndex
    }

    Button {
        id: nextBtn
        width: 100 * Devices.density
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Devices.navigationBarHeight
        anchors.right: parent.right
        flat: true
        highlighted: true
        text: qsTr("Next") + Translations.refresher
        visible: list.currentIndex < list.count - 1
        onClicked: list.currentIndex++
    }

    Button {
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
