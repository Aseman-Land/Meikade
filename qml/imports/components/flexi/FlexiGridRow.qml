import QtQuick 2.12
import QtQuick.Controls 2.9
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import queries 1.0
import "delegates"

FlexiAbstractRow {
    id: hflexible
    width: Constants.width
    height: gridItem.height

    property alias model: model
    property alias list: list
    property bool editMode: false
    property bool editable: false

    PointMapListener {
        id: mapListener
        source: gridItem
        dest: listView
    }

    Grid {
        id: gridItem
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10 * Devices.density
        columns: Math.floor( gridItem.width / (160 * Devices.density))

        Repeater {
            id: list
            model: FlexiSwitableModel {
                id: model
            }
            delegate: Loader {
                width: (hflexible.width - gridItem.spacing * (gridItem.columns - 1)) / gridItem.columns
                height: 100 * Devices.density * model.heightRatio
                active: 0 < globalY + height && globalY < listView.height

                property real globalY: mapListener.result.y + (Math.floor(model.index / gridItem.columns) * (height + gridItem.spacing))

                sourceComponent: Delegate {
                    id: itemDel
                    anchors.fill: parent
                    title: model.title + (isVerse? " - " + model.details.first_verse : "")
                    isVerse: model.details && model.details.first_verse? true : false
                    subtitle: model.subtitle
                    color: model.color.length? model.color : Colors.lightBackground
                    image: AsemanGlobals.testPoetImagesDisable? "" : model.image
                    type: model.type
                    link: model.link
                    moreHint: model.moreHint? model.moreHint : false
                    rotation: Math.sin(animValue) * 1 - 0.5
                    transformOrigin: Item.Center

                    property real animValue

                    NumberAnimation {
                        id: anim
                        target: itemDel
                        property: "animValue"
                        from: 0
                        to: Math.PI
                        running: editMode
                        duration: 200 + delay
                        loops: Animation.Infinite

                        property int delay
                        Component.onCompleted: delay = Math.random() * 100
                    }

                    onPressAndHold: if (editable) hflexible.editRequest(!editMode)
                    onClicked: {
                        if (editMode)
                            hflexible.editRequest(false)
                        else
                            hflexible.clicked(itemDel.link, list.model.get(index))
                    }
                    onMoreRequest: hflexible.moreRequest()

                    Loader {
                        anchors.fill: parent
                        active: editMode
                        sourceComponent: Item {

                            BusyIndicator {
                                id: busyIndic
                                anchors.centerIn: parent
                                width: 26 * Devices.density
                                height: width
                                running: offlineInstaller.installing || offlineInstaller.uninstalling || offlineInstaller.downloading
                                IOSStyle.foreground: "#fff"
                                Material.accent: "#fff"
                            }

                            Rectangle {
                                width: 22 * Devices.density
                                height: width
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.margins: -8 * Devices.density
                                radius: width / 2
                                color: Qt.darker(Colors.deepBackground, 1.2)
                                visible: !busyIndic.running

                                Label {
                                    anchors.centerIn: parent
                                    font.pixelSize: 7 * Devices.fontDensity
                                    font.family: MaterialIcons.family
                                    color: Colors.foreground
                                    text: MaterialIcons.mdi_minus
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    anchors.margins: -20 * Devices.density
                                    onClicked: offlineInstaller.checkAndInstall(false)
                                }
                            }

                            DataOfflineInstaller {
                                id: offlineInstaller
                                poetId: {
                                    var caps = Tools.stringRegExp(model.link, "^\\w+\\:\\/poet\\?id\\=(\\d+)$");
                                    if (caps.length === 0)
                                        return 0;

                                    return caps[0][1];
                                }
                                catId: 0
                            }
                        }
                    }

                }
            }
        }
    }
}
