import QtQuick 2.0
import QtGraphicalEffects 1.0
import AsemanQml.Base 2.0
import globals 1.0

Rectangle {
    id: base
    color: Colors.background

    readonly property real ratio: width/height
    property int counter

    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    Timer {
        interval: 500
        repeat: true
        running: true
        onTriggered: base.counter = (base.counter + 1) % 6
    }

    Item {
        id: imgBackFrame
        anchors.fill: parent

        Rectangle {
            width: img.width - 5 * Devices.density
            height: img.height - 5 * Devices.density
            anchors.centerIn: parent
            color: "#333"
            radius: 30 * Devices.density
        }
    }

    Rectangle {
        id: opacitySource
        anchors.fill: parent
        color: base.color
        visible: false
    }

    Repeater {
        id: rptr
        model: 5

        Rectangle {
            width: img.width - 10 * Devices.density
            height: img.height - 10 * Devices.density
            y: 5 * Devices.density
            x: base.width/2 - width/2 + width * (model.index - rptr.count/2 + 0.5) + padX
            transformOrigin: Item.Center
            color: Colors.lightBackground

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height / 3
                color: Colors.primary

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 10 * Devices.density
                    color: Qt.lighter(Colors.primary)
                }
            }

            Behavior on padX {
                NumberAnimation { easing.type: Easing.OutCubic; duration: 500 }
            }

            scale: upMask.opacity
            property real padX: {
                if (base.counter > 1 && base.counter < 7 )
                    return -width;
                return 0;
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: horizontalOffset
        width: 38 * Devices.density
        height: width
        radius: width/2
        color: "transparent"
        border.width: 4 * Devices.density
        border.color: "#888"
        opacity: (1 - upMask.opacity) * 3

        Behavior on horizontalOffset {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 400 }
        }

        property real horizontalOffset: {
            if (base.counter > 1 && base.counter < 7 )
                return -img.width * 0.4;
            return 0
        }
    }

    OpacityMask {
        id: upMask
        anchors.fill: parent
        maskSource: imgBackFrame
        source: opacitySource
        invert: true

        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
        }

        opacity: {
            if (base.counter < 1)
                return 1;
            if (base.counter > 2 && base.counter < 6 )
                return 1;
            if (base.counter > 7)
                return 1;

            return 0.8;
        }
    }

    Rectangle {
        id: grad
        width: base.height
        height: base.width
        anchors.centerIn: parent
        rotation: 90
        gradient: Gradient {
            GradientStop { position: 0.0 + grad.gradWidth; color: base.color }
            GradientStop { position: grad.gradWidth + (0.5 - grad.gradWidth) * 0.6 ; color: "transparent" }
            GradientStop { position: 1 - grad.gradWidth - (0.5 - grad.gradWidth) * 0.6; color: "transparent" }
            GradientStop { position: 1.0 - grad.gradWidth; color: base.color }
        }

        property real gradWidth: (base.width - img.width*3) / base.width / 2
    }

    Image {
        id: img
        anchors.centerIn: parent
        width: base.ratio > ratio? base.height * ratio : base.width
        height: base.ratio > ratio? base.height : base.width / ratio
        source: "images/mobile-frame.png"

        readonly property real ratio: 381/759
    }
}
