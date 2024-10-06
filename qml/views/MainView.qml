import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.GraphicalEffects 2.0
import components 1.0
import globals 1.0

MPage {
    id: page
    width: Constants.width
    height: Constants.height
    property alias myMeikadePage: myMeikadePage
    property alias searchPage: searchPage
    property alias homePage: homePage
    property alias explorePage: explorePage
    property alias swipeView: swipeView

    property alias currentIndex: swipeView.currentIndex

    signal footerItemDoubleClicked()

    MFooter {
        id: footer
        onCurrentIndexChanged: swipeView.currentIndex = currentIndex
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        MFooterButton {
            icon: footer.currentIndex == 0? MaterialIcons.mdi_home : MaterialIcons.mdi_home_outline
            text: qsTr("Home") + Translations.refresher
        }
        MFooterButton {
            icon: MaterialIcons.mdi_earth
            text: qsTr("Explore") + Translations.refresher
        }
        MFooterButton {
            icon: MaterialIcons.mdi_magnify
            text: qsTr("Search") + Translations.refresher
        }
        MFooterButton {
            icon: MaterialIcons.mdi_library
            text: qsTr("My Meikade") + Translations.refresher
        }
    }

    Rectangle {
        id: swipeView
        anchors.top: parent.top
        anchors.bottom: footer.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: AsemanGlobals.viewMode == 2? 0 : footerItem.width
        color: Colors.deepBackground
        clip: true

        property int currentIndex

        Item {
            id: homePage
            visible: swipeView.currentIndex == 0
            anchors.fill: parent
        }
        Item {
            id: explorePage
            visible: swipeView.currentIndex == 1
            anchors.fill: parent
        }
        Item {
            id: searchPage
            visible: swipeView.currentIndex == 2
            anchors.fill: parent
        }
        Item {
            id: myMeikadePage
            visible: swipeView.currentIndex == 3
            anchors.fill: parent
        }
    }
}
