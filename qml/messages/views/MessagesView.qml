import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Layouts 1.3
import globals 1.0
import components 1.0

DrawerFrame {
    height: 500 * Devices.density
    headerItem.anchors.topMargin: Devices.statusBarHeight
    headerLabel.text: qsTr("Messages") + Translations.refresher
    flickable.interactive: false

    property alias listView: listView

    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    signal linkClicked(string link)

    ColumnLayout {
        anchors.fill: parent
        anchors.bottomMargin: Devices.navigationBarHeight

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: ListView.Horizontal
            currentIndex: 0
            model: 20
            snapMode: ListView.SnapOneItem
            highlightRangeMode: ListView.StrictlyEnforceRange
            clip: true
            delegate: Item {
                id: msgItem
                width: listView.width
                height: listView.height

                LayoutMirroring.enabled: true
                LayoutMirroring.childrenInherit: true

                readonly property variant buttons: model.body.buttons

                ColumnLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10 * Devices.density
                    anchors.rightMargin: 10 * Devices.density
                    spacing: 0

                    AsemanFlickable {
                        id: flick
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        contentWidth: flickScene.width
                        contentHeight: flickScene.height
                        clip: true

                        Item {
                            id: flickScene
                            width: flick.width
                            height: Math.max(flick.height, column.height + 20 * Devices.density)

                            ColumnLayout {
                                id: column
                                anchors.topMargin: 10 * Devices.density
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top

                                MLabel {
                                    Layout.fillWidth: true
                                    font.pixelSize: 10 * Devices.fontDensity
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    text: model.title["text_" + GTranslations.localeName]
                                }

                                CachedImage {
                                    id: img
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 200 * Devices.density
                                    visible: model.image.length > 0
                                    source: model.image
                                    fillMode: Image.PreserveAspectFit
                                    ignoreSslErrors: AsemanGlobals.ignoreSslErrors
                                    asynchronous: true

                                    MBusyIndicator {
                                        anchors.centerIn: parent
                                        running: img.status != Image.Ready && img.visible
                                    }
                                }

                                MLabel {
                                    Layout.fillWidth: true
                                    font.pixelSize: 9 * Devices.fontDensity
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    text: model.body["text_" + GTranslations.localeName]
                                }
                            }
                        }
                    }

                    Repeater {
                        id: rptr
                        model: msgItem.buttons

                        MButton {
                            Layout.fillWidth: true
                            highlighted: true
                            font.pixelSize: 9 * Devices.fontDensity
                            text: modelData["text_" + GTranslations.localeName]
                            onClicked: linkClicked(modelData.link)
                        }
                    }
                }
            }
        }

        MPageIndicator {
            Layout.alignment: Qt.AlignHCenter
            count: listView.count
            currentIndex: listView.currentIndex
            interactive: false
        }
    }
}
