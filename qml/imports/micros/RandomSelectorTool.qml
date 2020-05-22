import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import globals 1.0

Rectangle {
    id: dis
    width: Constants.width
    height: Constants.height
    color: "#333"

    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    property color bookColor: Colors.primary
    property int count: 500
    readonly property int currentIndex: Math.min(Math.max(count * marea.mouseX, 0) / marea.width, randomList.count-1)
    property Item backScene: dis
    property Component delegate

    onCountChanged: refresh()
    Component.onCompleted: refresh()

    function refresh() {
        randomList.clear();
        for (var i=0; i<count; i++) {
            var idx = Math.floor(Math.random() * randomList.count);
            if (idx > randomList.count)
                idx = randomList.count;

            randomList.insert(idx, i+1);
        }
    }

    ListObject {
        id: randomList
    }

    Image {
        anchors.fill: parent
        source: "images/cover.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    Item {
        id: column
        anchors.centerIn: parent
        width: row.width
        height: row.height + header.height

        Item {
            id: header
            width: row.width
            height: 80 * Devices.density

            Rectangle {
                color: "#fff"
                width: indexLabel.width + 40 * Devices.density
                height: indexLabel.height + 20 * Devices.density
                radius: 10 * Devices.density
                x: Math.min(Math.max(marea.mouseX, 0), header.width) - width/2
                visible: marea.pressed

                Behavior on width {
                    NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.bottom
                    rotation: -45
                    width: 10 * Devices.density
                    height: width
                    color: "#fff"
                }

                Label {
                    id: indexLabel
                    anchors.centerIn: parent
                    font.pixelSize: 16 * Devices.fontDensity
                    color: "#333"
                    text: currentIndex>=0 && currentIndex < randomList.count? randomList.at(currentIndex) : ""
                }
            }
        }

        Rectangle {
            id: cover
            anchors.fill: row
            anchors.margins: -10 * Devices.density
            radius: 5 * Devices.density
            color: Qt.darker(bookColor)

            Rectangle {
                width: parent.height
                height: parent.width
                anchors.centerIn: parent
                rotation: 90
                radius: cover.radius
                gradient: Gradient {
                    GradientStop { position: 0.0; color: bookColor }
                    GradientStop { position: 0.1; color: "transparent" }
                    GradientStop { position: 0.9; color: "transparent" }
                    GradientStop { position: 1.0; color: bookColor }
                }
            }

            Rectangle {
                anchors.left: parent.left
                width: -cover.anchors.margins
                height: cover.height
                radius: cover.radius
                color: bookColor
            }

            Rectangle {
                anchors.right: parent.right
                width: -cover.anchors.margins
                height: cover.height
                radius: cover.radius
                color: bookColor
            }
        }

        Row {
            id: row
            spacing: 1
            anchors.bottom: parent.bottom

            Repeater {
                id: repeater
                model: dis.width * 0.5 / 4

                Rectangle {
                    height: dis.height - 180 * Devices.density
                    width: marea.visualIndex == index? 7 : 3
                    opacity: marea.visualIndex == index? 0 : 1

                    Behavior on width {
                        NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
                    }
                }
            }
        }
    }

    MouseArea {
        id: marea
        anchors.fill: column
        preventStealing: true
        onMouseXChanged: visualIndex = Math.max(0, Math.min(Math.floor(repeater.model * mouseX / width), repeater.model))
        onReleased: {
            if (currentIndex >= 0 && currentIndex < randomList.count) {
                var choice = randomList.at(currentIndex);
                var obj = paperComponent.createObject(backScene)
                obj.open = true
            }

            visualIndex = -1
        }

        property int visualIndex: -1
    }

    Component {
        id: paperComponent
        Item {
            id: paperItem
            anchors.fill: parent

            property real ratio: open? 1 : 0
            property alias open: opanAction.active

            onRatioChanged: if (ratio == 0) destroy()

            Component.onCompleted: {
                if (delegate) delegate.createObject(paper)
            }

            BackAction {
                id: opanAction
            }

            Behavior on ratio {
                NumberAnimation { easing.type: Easing.InOutCubic; duration: 500 }
            }

            Rectangle {
                anchors.fill: parent
                color: "#000"
                opacity: paperItem.ratio * 0.7
            }

            Rectangle {
                id: paper
                x: (marea.mouseX - marea.width/2) * (1 - paperItem.ratio)
                width: parent.width
                height: parent.height
                y: ((column.y + row.y) * (row.height / height)) * (1 - paperItem.ratio)
                scale: (row.height / height) * (1 - paperItem.ratio) * 0.9 + paperItem.ratio
                transform: Rotation {
                    origin.x: paper.width/2
                    origin.y: paper.height/2
                    axis { x: 0; y: 1; z: 0 }
                    angle: 90 * (1 - paperItem.ratio)
                }
            }
        }
    }
}
