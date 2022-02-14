import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import QtQuick.Controls 2.3
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtGraphicalEffects 1.0
import micros 1.0
import globals 1.0

Page {
    id: page
    width: Constants.width
    height: Constants.height
    property alias myMeikadePage: myMeikadePage
    property alias searchPage: searchPage
    property alias homePage: homePage
    property alias explorePage: explorePage
    property alias footerListView: footerListView
    property alias swipeView: swipeView

    property alias currentIndex: swipeView.currentIndex

    signal footerItemDoubleClicked()

    Rectangle {
        id: swipeView
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        color: Colors.deepBackground

        property int currentIndex

        onCurrentIndexChanged: footerListView.currentIndex = currentIndex;

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

    Item {
        anchors.fill: footerItem
        clip: true

        FastBlur {
            width: swipeView.width
            height: swipeView.height
            anchors.bottom: parent.bottom
            source: swipeView
            radius: Devices.isIOS || Devices.isDesktop? 64 : 0
            cached: true
            visible: Devices.isIOS || Devices.isDesktop
        }
    }

    Item {
        id: footerItem
        height: 58 * Devices.density + Devices.navigationBarHeight
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        Rectangle {
            anchors.fill: parent
            opacity: Devices.isIOS || Devices.isDesktop? 0.7 : 1
            color: Colors.background
        }

        Rectangle {
            id: footerBorder
            height: 1 * Devices.density
            color: Colors.foreground
            opacity: 0.1
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
        }

        ListView {
            id: footerListView
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Devices.navigationBarHeight
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width * 0.9, 400 * Devices.density)
            orientation: ListView.Horizontal
            maximumFlickVelocity: View.flickVelocity
            boundsBehavior: Flickable.StopAtBounds
            currentIndex: 0
            onCurrentIndexChanged: swipeView.currentIndex = currentIndex
            delegate: FooterItem {
                height: footerListView.height
                width: footerListView.width / footerListView.count
                iconText.text: MaterialIcons[ListView.isCurrentItem ? model.icon : model.icon_o]
                iconText.color: ListView.isCurrentItem ? (Colors.darkMode? Colors.accent : Colors.primary) : Colors.foreground
                iconText.font.pixelSize: model.iconSizeRatio * 18 * Devices.fontDensity
                title.text: model.name
                title.color: ListView.isCurrentItem ? (Colors.darkMode? Colors.accent : Colors.primary) : Colors.foreground

                Connections {
                    onClicked: {
                        if(currentIndex === model.index) footerItemDoubleClicked();
                        footerListView.currentIndex = model.index;
                    }
                    onDoubleClicked: footerItemDoubleClicked()
                }
            }

            model: AsemanListModel {
                data: [
                     {
                        name: qsTr("Home") + Translations.refresher,
                        icon: "mdi_home",
                        icon_o: "mdi_home_outline",
                        iconSizeRatio: 1.1
                    },
                    {
                       name: qsTr("Explore") + Translations.refresher,
                       icon: "mdi_earth",
                       icon_o: "mdi_earth",
                       iconSizeRatio: 1.1
                   },
                    {
                        name: qsTr("Search") + Translations.refresher,
                        icon: "mdi_magnify",
                        icon_o: "mdi_magnify",
                        iconSizeRatio: 1.1
                    },
                    {
                        name: qsTr("My Meikade") + Translations.refresher,
                        icon: "mdi_library",
                        icon_o: "mdi_library",
                        iconSizeRatio: 0.9
                    }
                ]
            }
        }
    }
}
