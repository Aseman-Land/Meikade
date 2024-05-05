import QtQuick 2.12
import globals 1.0
import components 1.0
import AsemanQml.Base 2.0

AbstractDelegate {
    id: adel
    width: Constants.width
    height: 100 * Devices.density
    property alias image: image
    property alias cachedImage: cachedImage
    property alias title: title
    property alias background: background

    Rectangle {
        anchors.fill: parent
        anchors.margins: 0.5
        color: Colors.primary
        radius: adel.radius
    }

    ImageDownloader {
        id: cachedImage
        ignoreSslErrors: AsemanGlobals.ignoreSslErrors
    }

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        sourceSize.width: 120 * Devices.density
        sourceSize.height: 120 * Devices.density
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#18f"
        radius: adel.radius
    }

    MLabel {
        id: title
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: 10 * Devices.density
        font.pixelSize: 9 * Devices.fontDensity
        text: "We needs change"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        maximumLineCount: 2
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        color: Colors.background
    }
}
