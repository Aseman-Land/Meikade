import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import requests 1.0
import globals 1.0
import components 1.0
import models 1.0

Page {
    id: dis
    width: Constants.width
    height: Constants.height

    Material.theme: Material.Light
    IOSStyle.theme: IOSStyle.Light

    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    signal loadRequest()

    component TestCheckItem: RowLayout {
        id: tcitem
        property alias text: lbl.text
        property alias checked: swt.checked

        signal toggled

        Label {
            id: lbl
            Layout.fillWidth: true
            font.pixelSize: 9 * Devices.fontDensity
            horizontalAlignment: Text.AlignLeft
        }

        Switch {
            id: swt
            checked: true
            onToggled: tcitem.toggled()
        }
    }

    AsemanFlickable {
        id: flick
        anchors.top: headerItem.bottom
        anchors.bottom: startBtn.top
        anchors.right: parent.right
        anchors.left: parent.left
        flickableDirection: Flickable.VerticalFlick
        clip: true

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
                anchors.margins: 20 * Devices.density
                spacing: 4 * Devices.density

                TestCheckItem {
                    text: "Feature: Logo"
                    onToggled: AsemanGlobals.testLogoDisable = !checked
                }

                TestCheckItem {
                    text: "Feature: Densities"
                    onToggled: Devices.setFlag(1, checked)
                }

                TestCheckItem {
                    text: "Feature: Poet Images"
                    onToggled: AsemanGlobals.testPoetImagesDisable = !checked
                }

                TestCheckItem {
                    text: "Feature: Header Images"
                    onToggled: AsemanGlobals.testHeaderImagesDisable = !checked
                }

                TestCheckItem {
                    text: "Page: Home"
                    onToggled: AsemanGlobals.testHomeDisable = !checked
                }

                TestCheckItem {
                    text: "Page: Search"
                    onToggled: AsemanGlobals.testSearchDisable = !checked
                }

                TestCheckItem {
                    text: "Page: My Meikade"
                    onToggled: AsemanGlobals.testMyMeikadeDisable = !checked
                }

                TestCheckItem {
                    text: "Page: Intro"
                    onToggled: AsemanGlobals.testIntroDisable = !checked
                }

            }
        }
    }

    Button {
        id: startBtn
        anchors.right: flick.right
        anchors.left: flick.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * Devices.density + Devices.navigationBarHeight
        anchors.margins: 20 * Devices.density
        highlighted: true
        font.pixelSize: 9 * Devices.fontDensity
        text: "Start"
        onClicked: dis.loadRequest()
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: "Configs Panel"
        color: "#fff"
        light: false
        shadow: isAndroidStyle
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: flick.bottom
        anchors.top: flick.top
        color: "#333"
        scrollArea: flick
    }
}

