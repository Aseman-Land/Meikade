import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import AsemanQml.Controls 2.0
import QtQuick.Controls.Material 2.0
import globals 1.0
import components 1.0
import models 1.0
import "privates"

Rectangle {
    id: poemView
    width: Constants.width
    height: Constants.height
    color: "#000"

    property alias form: form

    property alias viewCount: form.viewCount
    property alias cover: form.cover

    property variant neighbors
    property int neighborsIndex

    property Item menuObject

    signal changeRequest(string link, string title, string subtitle, int verse_id, string poetName)

    Timer {
        interval: 5
        repeat: false
        running: true
        onTriggered: form.listView.positionViewAtBeginning()
    }

    NumberAnimation {
        id: formXAnim
        target: form
        properties: "x"
        easing.type: Easing.OutCubic
        duration: 200
    }

    Timer {
        id: loader
        interval: 300
        repeat: false
        onTriggered: {
            form.x = 0;
            formCover.visible = true;
            formCover.opacity = 0;
            neighborsIndex = nextIndex;

            var unit = neighbors[neighborsIndex];
            poemView.changeRequest(unit.link, unit.title, unit.subtitle,
                                   (unit.verseId != undefined? unit.verseId : 0),
                                   (unit.poet != undefined? unit.poet : ""))
        }

        property int nextIndex: neighborsIndex
    }

    MouseArea {
        id: marea
        anchors.centerIn: parent
        width: Devices.isAndroid? poemView.width : poemView.width / 2
        height: poemView.height
        drag {
            target: neighbors && !menuObject? form : null
            axis: Drag.XAxis
            minimumX: -poemView.width
            maximumX: poemView.width
            filterChildren: true
            onActiveChanged: {
                if (marea.drag.active)
                    return;

                formXAnim.from = form.x;
                if (form.x < - width/2 && neighborsIndex > 0) {
                    formXAnim.to = -form.width;
                    loader.nextIndex = neighborsIndex - 1;
                } else if (form.x > width/2 && neighborsIndex+1 < neighbors.length) {
                    formXAnim.to = form.width;
                    loader.nextIndex = neighborsIndex + 1;
                } else {
                    formXAnim.to = 0;
                }

                formXAnim.start();

                if (loader.nextIndex != neighborsIndex) {
                    loader.start();
                    formCover.visible = false;
                    formCover.opacity = 1;
                }
            }
        }

        Item {
            id: poemScene
            anchors.centerIn: parent
            width: poemView.width
            height: poemView.height

            PoemViewNeighbor {
                anchors.left: form.right
                scale: form.scale
                poet: unit && unit.poet != undefined? unit.poet : form.poet
                visible: neighbors? neighborsIndex+1 < neighbors.length : false
                unit: neighbors? neighbors[neighborsIndex+1] : null
            }

            PoemViewNeighbor {
                anchors.right: form.left
                scale: form.scale
                poet: unit && unit.poet != undefined? unit.poet : form.poet
                visible: neighborsIndex > 0
                unit: neighbors? neighbors[neighborsIndex-1] : null
            }

            PoemForm {
                id: form
                x: parent.width/2 - width/2
                width: parent.width
                height: parent.height
                scale: marea.drag.active? 0.9 : 1

                PoemViewNeighbor {
                    id: formCover
                    poet: form.poet
                    unit: neighbors? neighbors[neighborsIndex] : null
                    visible: false;

                    Behavior on opacity {
                        NumberAnimation { easing.type: Easing.OutCubic; duration: 200 }
                    }
                }

                Behavior on highlighItemRatio {
                    NumberAnimation { duration: 500 }
                }
                Behavior on selectModeAnimRatio {
                    NumberAnimation { easing.type: Easing.OutCubic; duration: 200 }
                }
                Behavior on scale {
                    NumberAnimation { easing.type: Easing.OutCubic; duration: 200 }
                }
                Behavior on coverScene.y {
                    NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
                }
                Behavior on statusBarRect.opacity {
                    NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
                }
            }
        }
    }
}

