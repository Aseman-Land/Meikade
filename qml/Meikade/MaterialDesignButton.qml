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

    Item {
        width: opened? 200*Devices.density : 64*Devices.density
        height: opened? 170*Devices.density : 64*Devices.density
        x: md_btn.layoutDirection==Qt.LeftToRight? parent.width-width-10*Devices.density : 10*Devices.density
        anchors.bottom: parent.bottom
        anchors.margins: 10*Devices.density
        clip: opened

        Behavior on width {
            NumberAnimation{easing.type: Easing.OutCubic; duration: 200}
        }
        Behavior on height {
            NumberAnimation{easing.type: Easing.OutCubic; duration: 200}
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
                color: opened? "#ffffff" : "#881010"
                radius: opened? 6*Devices.density : width/2

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
            onClicked: opened = true
        }

        Image {
            anchors.centerIn: btn_rect
            width: 26*Devices.density
            height: width
            sourceSize: Qt.size(width,height)
            visible: !opened
            source: "icons/new.png"
        }

        Column {
            width: 180*Devices.density
            height: 150*Devices.density
            x: md_btn.layoutDirection==Qt.LeftToRight? parent.width-width-10*Devices.density : 10*Devices.density
            anchors.bottom: btn_rect.bottom
            anchors.margins: 10*Devices.density
            visible: opened

            Button {
                width: parent.width
                height: parent.height/3
                normalColor: "#00000000"
                highlightColor: "#440d80ec"
                textColor: "#333333"
                fontSize: 10*Devices.fontDensity
                textFont.bold: false
                text: qsTr("Hafez Omen")
                onClicked: {
                    md_btn.hafezOmenRequest()
                    close_timer.restart()
                }
            }

            Button {
                width: parent.width
                height: parent.height/3
                normalColor: "#00000000"
                highlightColor: "#440d80ec"
                textColor: "#333333"
                fontSize: 10*Devices.fontDensity
                textFont.bold: false
                text: qsTr("Random Poem")
                onClicked: {
                    md_btn.randomPoemRequest()
                    close_timer.restart()
                }
            }

            Button {
                width: parent.width
                height: parent.height/3
                normalColor: "#00000000"
                highlightColor: "#440d80ec"
                textColor: "#333333"
                fontSize: 10*Devices.fontDensity
                textFont.bold: false
                text: qsTr("Search")
                onClicked: {
                    md_btn.searchRequest()
                    close()
                }
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

