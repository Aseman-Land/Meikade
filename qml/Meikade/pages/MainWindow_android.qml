import QtQuick 2.0
import Pinterest.Base 1.0
import Pinterest.Lists 1.0 as Lists
import AsemanQml.Base 2.0
import QtQuick.Controls 2.1 as QtControls
import "../models" as Models
import "../globals"

QtControls.Page {

    AsemanListView {
        id: listv
        anchors.fill: parent
        model: Models.CategoryModel { catId: 0 }
        header: Lists.RollerDoubleHeader {
            id: superHeader
            width: listv.width
            masterHeaderMinimumHeight: Devices.standardTitleBarHeight
            masterHeaderHeight: 200*Devices.density
            masterHeaderColor: "transparent"
            masterHeader.opacity: 1
            masterItem: Item {
                width: listv.width
                clip: true

                Rectangle {
                    anchors.fill: parent
                    color: MeikadeGlobals.masterColor
                    opacity: 1 - superHeader.masterRatio
                }

                Image {
                    anchors.centerIn: parent
                    width: 100*Devices.density
                    height: width
                    scale: 0.5 + superHeader.masterRatio/2
                    source: "../icons/meikade_t.png"
                    sourceSize: Qt.size(width*1.2, height*1.2)
                    opacity: superHeader.masterRatio
                }

                Image {
                    anchors.centerIn: parent
                    width: 100*Devices.density
                    height: width
                    scale: 0.5 + superHeader.masterRatio/2
                    source: "../icons/meikade_t_light.png"
                    sourceSize: Qt.size(width*1.2, height*1.2)
                    opacity: 1 - superHeader.masterRatio
                }
            }
            property real masterRatio: (masterItem.height-masterHeaderMinimumHeight)/(masterHeaderHeight-masterHeaderMinimumHeight)

            subItem: Rectangle {
                color: MeikadeGlobals.backgroundColor
                radius: superHeader.masterRatio * 5*Devices.density
            }

            subHeaderColor: "transparent"

            shadowColor: "#333"
        }
        delegate: Item {
            width: listv.width
            height: 50*Devices.density

            QtControls.Label {
                anchors.centerIn: parent
                font.pixelSize: 9*Devices.fontDensity
                text: model.identifier==-1? qsTr("Other Poems") : Database.catName(model.identifier)
            }

            QtControls.ItemDelegate {
                anchors.fill: parent
            }
        }
    }
}
