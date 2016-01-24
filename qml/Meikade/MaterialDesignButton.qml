import QtQuick 2.0
import AsemanTools 1.0
import QtGraphicalEffects 1.0

Item {
    id: md_btn
    anchors.fill: parent
    anchors.bottomMargin: View.navigationBarHeight

    property bool hideState: false
    property bool opened: false

    signal hafezOmenRequest()
    signal randomPoemRequest()
    signal searchRequest()

    property int layoutDirection: Qt.LeftToRight

    onHideStateChanged: {
        hide_timer.stop()
        if(hideState)
            hide_timer.start()
        else
            md_btn.visible = true
    }

    onOpenedChanged: {
        if(opened)
            BackHandler.pushHandler(md_btn, md_btn.close)
        else
            BackHandler.removeHandler(md_btn)
    }

    MouseArea {
        anchors.fill: parent
        visible: opened
        onClicked: opened = false
    }

    Timer {
        id: hide_timer
        interval: 400
        onTriggered: md_btn.visible = false
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: View.statusBarHeight + Devices.standardTitleBarHeight
        anchors.bottomMargin: -View.navigationBarHeight
        opacity: opened? 0.6 : 0
        color: "#ffffff"

        Behavior on opacity {
            NumberAnimation{easing.type: Easing.OutCubic; duration: 300}
        }
    }

    Item {
        width: 64*Devices.density
        height: 64*Devices.density
        x: md_btn.layoutDirection==Qt.LeftToRight? parent.width-width-10*Devices.density : 10*Devices.density
        anchors.bottom: parent.bottom
        anchors.margins: 10*Devices.density

        Item {
            x: md_btn.layoutDirection==Qt.LeftToRight? parent.width-width : 0
            height: opened? 200*Devices.density : 0
            width: 200*Devices.density
            anchors.bottom: btn_rect.top
            opacity: opened? 1 : 0

            Behavior on height {
                NumberAnimation{easing.type: Easing.OutBack; duration: 300}
            }
            Behavior on opacity {
                NumberAnimation{easing.type: Easing.OutCubic; duration: 200}
            }

            MaterialDesignButtonItem {
                id: omen_btn
                anchors.top: parent.top
                height: parent.height/3
                text: qsTr("Hafez Omen")
                icon: "icons/button-omen.png"
                onClicked: {
                    networkFeatures.pushAction("Hafez Omen")
                    md_btn.hafezOmenRequest()
                    close()
                }
            }

            MaterialDesignButtonItem {
                id: random_btn
                anchors.top: omen_btn.bottom
                height: parent.height/3
                text: qsTr("Random Poem")
                icon: "icons/button-random.png"
                onClicked: {
                    networkFeatures.pushAction("Random Poem")
                    md_btn.randomPoemRequest()
                    close()
                }
            }

            MaterialDesignButtonItem {
                id: search_btn
                anchors.top: random_btn.bottom
                height: parent.height/3
                text: qsTr("Search")
                icon: "icons/button-search.png"
                onClicked: {
                    networkFeatures.pushAction("Search")
                    md_btn.searchRequest()
                    close_timer.restart()
                }
            }
        }

        Item {
            id: btn_rect
            y: hideState? parent.height+20*Devices.density+View.navigationBarHeight : 0
            width: parent.width
            height: parent.height
            visible: false

            Behavior on y {
                NumberAnimation{easing.type: Easing.OutCubic; duration: 400}
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 8*Devices.density
                color: "#881010"
                radius: width/2

                Behavior on color {
                    ColorAnimation{easing.type: Easing.OutCubic; duration: 400}
                }
            }
        }

        DropShadow {
            anchors.fill: btn_rect
            horizontalOffset: 0
            verticalOffset: 1
            radius: 8.0
            samples: 16
            color: "#aa000000"
            source: btn_rect
        }

        MouseArea {
            anchors.fill: parent
            onClicked: opened = !opened
        }

        Image {
            anchors.centerIn: btn_rect
            width: 22*Devices.density
            height: width
            sourceSize: Qt.size(width,height)
            rotation: opened? 0 : -45
            source: "icons/button-close.png"
            transformOrigin: Item.Center

            Behavior on rotation {
                NumberAnimation{easing.type: Easing.OutBack; duration: 300}
            }
        }
    }

    Timer {
        id: close_timer
        interval: 800
        onTriggered: close()
    }

    function hide() {
        hideState = true
    }

    function show() {
        hideState = false
    }

    function close() {
        opened = false
    }
}

