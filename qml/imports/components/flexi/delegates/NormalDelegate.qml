import QtQuick 2.12
import globals 1.0
import components 1.0
import QtQuick.Layouts 1.3
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.GraphicalEffects 2.0

AbstractDelegate {
    id: delItem
    width: 400
    height: 100 * Devices.density
    property alias subtitle: subtitle
    property alias cachedImage: cachedImage
    property alias image: image
    property alias title: title
    property alias background: background
    property alias blurImage: blurImage

    Rectangle {
        anchors.fill: parent
        anchors.margins: 0.5
        color: Colors.primary
        radius: delItem.radius
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#18f"
        radius: delItem.radius

        Image {
            id: blurImage
            height: parent.height
            width: height
            anchors.right: parent.right
            opacity: 0.7
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }

        Rectangle {
            width: parent.height
            height: parent.width
            anchors.centerIn: parent
            rotation: LayoutMirroring.enabled? -90 : 90
            radius: delItem.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: (blurImage.width - delItem.radius) / background.width; color: background.color }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10 * Devices.density
        spacing: imageScene.visible? 10 * Devices.density : 8 * Devices.density

        MLabel {
            id: title
            Layout.fillWidth: true
            font.pixelSize: 9 * Devices.fontDensity
            text: "Title Poet"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 1
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: Colors.background
        }

        RowLayout {
            Layout.fillWidth: true

            MLabel {
                id: subtitle
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                font.pixelSize: 8 * Devices.fontDensity
                text: "Short Description"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
                color: Colors.background
            }

            Item {
                id: imageScene
                Layout.alignment: Qt.AlignBottom | Qt.AlignRight
                height: 42 * Devices.density
                width: 42 * Devices.density
                visible: (cachedImage.source + "").length > 0

                ImageDownloader {
                    id: cachedImage
                    ignoreSslErrors: AsemanGlobals.ignoreSslErrors
                }

                Rectangle {
                    anchors.fill: parent
                    color: Qt.darker(background.color, 1.3)
                    radius: delItem.radius / 2
                    visible: (image.source + "").length == 0

                    MLabel {
                        anchors.centerIn: parent
                        font.family: MaterialIcons.family
                        font.pixelSize: 15 * Devices.fontDensity
                        text: MaterialIcons.mdi_account
                        color: "#ffffff"
                    }
                }

                Image {
                    id: image
                    anchors.fill: parent
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    sourceSize.width: 100 * Devices.density
                    sourceSize.height: 100 * Devices.density
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
            }
        }
    }
}
