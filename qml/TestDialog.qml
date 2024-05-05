import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Layouts 1.3
import requests 1.0
import globals 1.0
import components 1.0
import models 1.0

MPage {
    id: dis
    width: Constants.width
    height: Constants.height

    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    signal loadRequest()

    component TestCheckItem: RowLayout {
        id: tcitem
        property alias text: lbl.text
        property alias checked: swt.checked

        signal toggled

        MLabel {
            id: lbl
            Layout.fillWidth: true
            font.pixelSize: 9 * Devices.fontDensity
            horizontalAlignment: Text.AlignLeft
        }

        MSwitch {
            id: swt
            checked: true
            onToggled: tcitem.toggled()
        }
    }

    AsemanFlickable {
        id: flick
        anchors.fill: parent
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

    MButton {
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

    header: MHeader {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        title: "Configs Panel"
    }

    HScrollBar {
        anchors.right: parent.right
        anchors.bottom: flick.bottom
        anchors.top: flick.top
        color: "#333"
        scrollArea: flick
    }
}

