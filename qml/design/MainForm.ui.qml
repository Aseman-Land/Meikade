import QtQuick 2.12
import MeikadeDesign 1.0
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import "micro"

Page {
    id: page
    width: Constants.width
    height: Constants.height
    property alias myMeikadePage: myMeikadePage
    property alias searchPage: searchPage
    property alias homePage: homePage
    property alias footerListView: footerListView
    property alias swipeView: swipeView

    Rectangle {
        id: swipeView
        anchors.top: parent.top
        anchors.bottom: footerItem.top
        anchors.right: parent.right
        anchors.left: parent.left
        color: Constants.background

        property int currentIndex

        Item {
            id: homePage
            visible: swipeView.currentIndex == 0
            anchors.fill: parent
        }
        Item {
            id: searchPage
            visible: swipeView.currentIndex == 1
            anchors.fill: parent
        }
        Item {
            id: myMeikadePage
            visible: swipeView.currentIndex == 2
            anchors.fill: parent
        }
    }

    Rectangle {
        id: footerItem
        height: 58 * Devices.density
        color: Material.background
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        Rectangle {
            id: footerBorder
            height: 1 * Devices.density
            color: Material.foreground
            opacity: 0.1
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
        }

        RowLayout {
            id: footerLayout
            anchors.fill: parent
        }

        ListView {
            id: footerListView
            anchors.fill: parent
            anchors.leftMargin: parent.width / 10
            anchors.rightMargin: parent.width / 10
            orientation: ListView.Horizontal
            maximumFlickVelocity: View.flickVelocity
            boundsBehavior: Flickable.StopAtBounds
            currentIndex: 0
            onCurrentIndexChanged: swipeView.currentIndex = currentIndex
            delegate: FooterItem {
                height: footerListView.height
                width: footerListView.width / footerListView.count
                iconText.text: MaterialIcons[ListView.isCurrentItem ? model.icon : model.icon_o]
                iconText.color: ListView.isCurrentItem ? Material.primary : Material.foreground
                iconText.font.pixelSize: model.iconSizeRatio * 18 * Devices.fontDensity
                title.text: model.name
                title.color: ListView.isCurrentItem ? Material.primary : Material.foreground
                onClicked: footerListView.currentIndex = model.index
            }

            model: ListModel {

                ListElement {
                    name: qsTr("Home")
                    icon: "mdi_home"
                    icon_o: "mdi_home_outline"
                    iconSizeRatio: 1.1
                }

                ListElement {
                    name: qsTr("Search")
                    icon: "mdi_magnify"
                    icon_o: "mdi_magnify"
                    iconSizeRatio: 1.1
                }

                ListElement {
                    name: qsTr("My Meikade")
                    icon: "mdi_library"
                    icon_o: "mdi_library"
                    iconSizeRatio: 0.9
                }
            }
        }
    }
}
