import QtQuick 2.0
import AsemanTools 1.0
import AsemanTools.Awesome 1.0

Rectangle {
    id: cat_item
    width: parent.width
    x: {
        if(outside) {
            if(View.layoutDirection==Qt.LeftToRight)
                return -parent.width
            else
                return parent.width
        } else {
            return 0
        }
    }
    y: startInit? 0 : startY
    height: startInit? parent.height : startHeight
    clip: true
    color: Meikade.nightTheme? "#222222" : "#dddddd"

    property alias catId: category.catId
    property alias root: cat_title.root

    property bool outside: false
    property bool startInit: false

    property real startY: 0
    property real startHeight: 0

    signal categorySelected( int cid, variant rect )
    signal poemSelected( int pid, variant rect )

    Behavior on x {
        NumberAnimation{ easing.type: Easing.OutCubic; duration: destroy_timer.interval }
    }
    Behavior on y {
        NumberAnimation{ easing.type: Easing.OutCubic; duration: destroy_timer.interval }
    }
    Behavior on height {
        NumberAnimation{ easing.type: Easing.OutCubic; duration: destroy_timer.interval }
    }

    Timer {
        id: destroy_timer
        interval: 400
        onTriggered: cat_item.destroy()
    }

    Timer {
        id: start_timer
        interval: 400
        onTriggered: cat_item.startInit = true
    }

    Category {
        id: category
        topMargin: item.visible? item.height : 0
        height: cat_item.parent.height
        width: cat_item.parent.width
        header: root? desc_component : spacer_component
        onCategorySelected: cat_item.categorySelected(cid, rect)
        onPoemSelected: cat_item.poemSelected(pid, rect)
    }

    Rectangle {
        id: item
        x: category.itemsSpacing
        width: category.width - 2*x
        height: 55*Devices.density
        border.width: 1*Devices.density
        border.color: Meikade.nightTheme? "#444444" : "#cccccc"
        opacity: startInit? 0 : 1
        color: Meikade.nightTheme? "#222222" : "#ffffff"
        visible: cat_title.cid != 0

        Behavior on opacity {
            NumberAnimation{ easing.type: Easing.OutCubic; duration: destroy_timer.interval }
        }
    }

    Rectangle {
        height: item.height
        width: parent.width
        color: Meikade.nightTheme? "#e0000000" : "#e0ffffff"
        opacity: startInit? 1 : 0
        visible: cat_title.cid != 0

        MouseArea {
            anchors.fill: parent
        }

        Button{
            id: rand_btn
            anchors.right: View.layoutDirection==Qt.LeftToRight? parent.right : undefined
            anchors.left: View.layoutDirection==Qt.LeftToRight? undefined : parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            radius: 0
            normalColor: "transparent"
            highlightColor: "#22000000"
            iconHeight: 25*Devices.density
            visible: true
            onClicked: {
                cat_page.showRandomCatPoem(catId)
            }

            Text {
                anchors.centerIn: parent
                font.pixelSize: 13*globalFontDensity*Devices.fontDensity
                font.family: Awesome.family
                color: "#3d3d3d"
                text: Awesome.fa_random
            }
        }

        Behavior on opacity {
            NumberAnimation{ easing.type: Easing.OutCubic; duration: destroy_timer.interval }
        }

        TitleBarShadow {
            width: parent.width
            anchors.top: parent.bottom
            height: 2*Devices.density
            opacity: 0.4
        }
    }

    CategoryItem {
        id: cat_title
        anchors.fill: item
        cid: category.catId
    }

    Component {
        id: spacer_component
        Item {
            height: category.itemsSpacing
            width: 2
        }
    }

    Component {
        id: desc_component
        Rectangle {
            id: desc_header
            width: cat_item.width
            height: expand? desc_text.height + desc_text.y*2 : 80*Devices.density
            color: Meikade.nightTheme? "#111111" : "#333333"
            clip: true

            property bool expand: false

            onExpandChanged: {
                if( expand )
                    BackHandler.pushHandler( desc_header, desc_header.unexpand )
                else
                    BackHandler.removeHandler(desc_header)
            }

            Behavior on height {
                NumberAnimation{ easing.type: Easing.OutCubic; duration: 400 }
            }

            Text {
                id: desc_text
                anchors.left: parent.left
                anchors.right: parent.right
                y: 8*Devices.density
                anchors.margins: y
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                color: "#ffffff"
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                text: Database.poetDesctiption(catId)
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 30*Devices.density
                opacity: desc_header.expand? 0 : 1
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#00000000" }
                    GradientStop { position: 1.0; color: desc_header.color }
                }

                Behavior on opacity {
                    NumberAnimation { easing.type: Easing.OutCubic; duration: 400 }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: desc_header.expand = !desc_header.expand
            }

            function unexpand() {
                expand = false
            }
        }
    }

    function start() {
        start_timer.start()
    }

    function end() {
        startInit = false
        destroy_timer.start()
    }

    ActivityAnalizer { object: cat_item; comment: cat_item.catId }
}
