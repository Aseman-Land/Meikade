import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import components 1.0
import models 1.0
import "privates"

Page {
    id: dis
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias textLabel: textLabel
    property alias closeBtn: closeBtn

    AsemanFlickable {
        id: flick
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height
        bottomMargin: Devices.navigationBarHeight

        Item {
            id: scene
            width: flick.width
            height: Math.max(sceneColumn.height + 20 * Devices.density,
                             flick.height)

            ColumnLayout {
                id: sceneColumn
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 10 * Devices.density
                anchors.margins: 10 * Devices.density
                spacing: 20 * Devices.density

                Image {
                    Layout.topMargin: 20 * Devices.density
                    Layout.fillWidth: true
                    Layout.preferredHeight: 128 * Devices.density
                    horizontalAlignment: Image.AlignHCenter
                    source: "../home/icons/meikade.png"
                    sourceSize.width: 140 * Devices.density
                    sourceSize.height: 140 * Devices.density
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    id: textLabel
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignLeft
                    Layout.bottomMargin: 10 * Devices.density
                    textFormat: Text.MarkdownText
                    lineHeight: 1.2
                }
            }
        }
    }

    HScrollBar {
        scrollArea: flick
        anchors.top: flick.top
        anchors.bottom: flick.bottom
        anchors.right: flick.right
        color: Colors.primary
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("ChangeLogs") + Translations.refresher
        color: Colors.headerColor
        light: !Colors.lightHeader
        shadow: isAndroidStyle

        HeaderBackButton {
            id: closeBtn
        }
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: flick.bottom
        anchors.top: flick.top
        color: "#fff"
        scrollArea: flick
    }
}

