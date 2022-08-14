import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Models 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import components 1.0
import globals 1.0

Page {
    id: form
    width: Constants.width
    height: Constants.height

    property alias scene: scene
    property alias busyIndicator: busyIndicator
    property alias closeBtn: closeBtn
    property alias finishBtn: finishBtn
    property alias agreement: agreement
    property alias agreementAcceptBtn: agreementAcceptBtn
    property alias agreementAcceptBtnIndicator: agreementAcceptBtnIndicator
    property alias reviewAcceptBtn: reviewAcceptBtn
    property alias reviewAcceptBtnIndicator: reviewAcceptBtnIndicator
    property alias reviewModel: reviewModel
    property alias reviewListV: reviewListV
    property real initedNum: 0
    property real agreementNum: 0
    property real reviewNum: 0
    property real finishNum: 0
    property real progress: 0

    signal poemClicked(int poemId, string text, int type)
    signal reloadStatesRequest();

    Rectangle {
        anchors.fill: parent
        color: Colors.background
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        color: Colors.deepBackground

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 30 * Devices.density

                Item {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 8 * Devices.density
                    height: 4 * Devices.density

                    Rectangle {
                        anchors.fill: parent
                        radius: height / 2
                        color: Colors.foreground
                        opacity: 0.2
                    }

                    Rectangle {
                        height: parent.height
                        anchors.left: parent.left
                        width: parent.width * form.progress
                        radius: height / 2
                        color: Colors.accent
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.leftMargin: 8 * Devices.density
                Layout.rightMargin: 8 * Devices.density
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 10 * Devices.fontDensity
                text: finishNum > 0? qsTr("Finished") : reviewNum > 0? qsTr("Review") : qsTr("Agreement") + Translations.refresher
            }

            Item {
                id: scene
                Layout.topMargin: 13 * Devices.density
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ColumnLayout {
                    anchors.margins: 8 * Devices.density
                    anchors.left: parent.left
                    anchors.right: parent.right
                    scale: 1 - reviewNum * 0.3
                    y: parent.height * (1 - agreementNum) + 8 * Devices.density
                    height: parent.height - 16 * Devices.density
                    spacing: 4 * Devices.density

                    Rectangle {
                        id: agreementScene
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 6 * Devices.density
                        color: Colors.lightBackground
                        clip: true

                        AsemanFlickable {
                            id: agreementFlick
                            anchors.fill: parent
                            flickableDirection: Flickable.VerticalFlick
                            contentWidth: agreement.width
                            contentHeight: agreement.height

                            Label {
                                id: agreement
                                width: agreementFlick.width
                                topPadding: 10 * Devices.density
                                bottomPadding: 10 * Devices.density
                                leftPadding: 10 * Devices.density
                                rightPadding: 10 * Devices.density
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                font.pixelSize: 9 * Devices.fontDensity
                            }
                        }

                        HScrollBar {
                            scrollArea: agreementFlick
                            anchors.right: agreementFlick.right
                            anchors.top: agreementFlick.top
                            anchors.bottom: agreementFlick.bottom
                            color: Colors.primary
                        }
                    }

                    Button {
                        id: agreementAcceptBtn
                        Layout.fillWidth: true
                        opacity: 1 - reviewNum
                        visible: opacity > 0
                        font.pixelSize: 9 * Devices.fontDensity
                        highlighted: true
                        text: agreementAcceptBtnIndicator.running? "" : qsTr("Accept Agreement") + Translations.refresher

                        BusyIndicator {
                            id: agreementAcceptBtnIndicator
                            anchors.centerIn: parent
                            scale: 0.6
                            height: 28 * Devices.density
                            width: 28 * Devices.density
                            running: false
                            IOSStyle.foreground: "#fff"
                            Material.accent: "#fff"
                        }
                    }
                }

                ColumnLayout {
                    anchors.margins: 8 * Devices.density
                    anchors.left: parent.left
                    anchors.right: parent.right
                    scale: 1 - finishNum * 0.3
                    y: parent.height * (1 - reviewNum) + 8 * Devices.density
                    height: parent.height - 16 * Devices.density
                    spacing: 4 * Devices.density

                    Rectangle {
                        id: reviewScene
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Colors.deepBackground
                        clip: true

                        Label {
                            anchors.centerIn: parent
                            font.pixelSize: 8 * Devices.fontDensity
                            text: qsTr("There is no poem in the book") + Translations.refresher
                            visible: reviewListV.count == 0
                            opacity: 0.6
                        }

                        AsemanListView {
                            id: reviewListV
                            anchors.fill: parent
                            spacing: 4 * Devices.density
                            enabled: !reviewAcceptBtnIndicator.running
                            opacity: reviewAcceptBtnIndicator.running? 0.7 : 1
                            model: AsemanListModel {
                                id: reviewModel
                            }
                            section.property: "section"
                            section.criteria: ViewSection.FullString
                            section.delegate: Item {
                                width: reviewListV.width
                                height: sectionLabel.text.length? 30 * Devices.density : 0
                                opacity: sectionLabel.text.length? 1 : 0

                                Label {
                                    id: sectionLabel
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 8 * Devices.density
                                    anchors.bottomMargin: 4 * Devices.density
                                    horizontalAlignment: Text.AlignLeft
                                    font.pixelSize: 9 * Devices.fontDensity
                                    text: section
                                }
                            }
                            delegate: Item {
                                width: reviewListV.width
                                height: 58 * Devices.density

                                Rectangle {
                                    radius: 6 * Devices.density
                                    color: Colors.lightBackground
                                    anchors.fill: parent

                                    ItemDelegate {
                                        anchors.fill: parent

                                        Connections {
                                            onClicked: form.poemClicked(model.poemId, model.text, model.type)
                                        }
                                    }

                                    RowLayout {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.margins: 8 * Devices.density

                                        CheckBox {
                                            checked: model.checked
                                            Connections {
                                                onClicked: {
                                                    model.checked = !model.checked;
                                                    form.reloadStatesRequest();
                                                }
                                            }
                                        }

                                        ColumnLayout {
                                            spacing: 0 * Devices.density
                                            Layout.fillWidth: true

                                            Label {
                                                text: model.title
                                                Layout.fillWidth: true
                                                horizontalAlignment: Text.AlignLeft
                                                font.pixelSize: 9 * Devices.fontDensity
                                            }

                                            Label {
                                                text: model.first_verse
                                                Layout.fillWidth: true
                                                horizontalAlignment: Text.AlignLeft
                                                font.pixelSize: 8 * Devices.fontDensity
                                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                                maximumLineCount: 1
                                                elide: Text.ElideRight
                                                opacity: 0.7
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        HScrollBar {
                            scrollArea: reviewListV
                            anchors.right: reviewListV.right
                            anchors.top: reviewListV.top
                            anchors.bottom: reviewListV.bottom
                            color: Colors.primary
                        }
                    }

                    Button {
                        id: reviewAcceptBtn
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        highlighted: true
                        opacity: 1 - finishNum
                        visible: opacity > 0
                        text: reviewAcceptBtnIndicator.running? "" : qsTr("Upload to Review") + Translations.refresher

                        BusyIndicator {
                            id: reviewAcceptBtnIndicator
                            anchors.centerIn: parent
                            scale: 0.6
                            height: 28 * Devices.density
                            width: 28 * Devices.density
                            running: false
                            IOSStyle.foreground: "#fff"
                            Material.accent: "#fff"
                        }
                    }
                }

                ColumnLayout {
                    anchors.margins: 8 * Devices.density
                    anchors.left: parent.left
                    anchors.right: parent.right
                    y: parent.height * (1 - finishNum) + 8 * Devices.density
                    height: parent.height - 16 * Devices.density
                    spacing: 4 * Devices.density

                    Rectangle {
                        id: finishScene
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 6 * Devices.density
                        color: Colors.background

                        MouseArea {
                            anchors.fill: parent
                        }

                        ColumnLayout {
                            anchors.margins: 12 * Devices.density
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                font.pixelSize: 60 * Devices.fontDensity
                                font.family: MaterialIcons.family
                                text: MaterialIcons.mdi_check
                                color: Colors.accent
                            }

                            Label {
                                Layout.fillWidth: true
                                font.pixelSize: 9 * Devices.fontDensity
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("Your request for review submitted officialy. We will publish your poems and notify you when review finished.") + Translations.refresher
                            }

                            Label {
                                Layout.fillWidth: true
                                font.pixelSize: 9 * Devices.fontDensity
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr("You can check state of the review by click on the below icon on the top-right of the My Meikade page.") + Translations.refresher
                            }

                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                font.pixelSize: 30 * Devices.fontDensity
                                font.family: MaterialIcons.family
                                text: MaterialIcons.mdi_inbox
                                color: Colors.accent
                            }
                        }
                    }

                    Button {
                        id: finishBtn
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        highlighted: true
                        text: qsTr("Finish") + Translations.refresher
                    }
                }
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        anchors.centerIn: parent
        running: false
    }

    Header {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        color: Colors.headerColor
        light: !Colors.lightHeader
        shadow: Devices.isAndroid

        Image {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: Devices.statusBarHeight/2
            width: 160 * Devices.density
            height: 160 * Devices.density
            scale: 0.3 + 0.5 * (1 - initedNum)
            source: Colors.lightHeader? "qrc:/qml/explore/views/icons/meikade.png" : "qrc:/qml/explore/views/icons/meikade-abstract.png"
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectFit
        }

        HeaderBackButton {
            id: closeBtn
        }
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height * (1 - initedNum) + 0 * initedNum
        clip: true

        Rectangle {
            width: form.height * 1.5
            height: width
            anchors.centerIn: parent
            rotation: 45
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.darker(Colors.primary, 2) }
                GradientStop { position: 1.0; color: Colors.primary }
            }
        }

        ColumnLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            y: Math.max(parent.height, headerItem.height)/2 - height/2 * (1 - initedNum) - (mkd_logo.height/2 + Devices.statusBarHeight/2) * initedNum
            spacing: 4 * Devices.density

            Image {
                id: mkd_logo
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 160 * Devices.density
                Layout.preferredHeight: 160 * Devices.density
                scale: 0.3 + 0.5 * (1 - initedNum)
                source: "qrc:/qml/explore/views/icons/meikade-abstract.png"
                sourceSize.width: 200 * Devices.density
                sourceSize.height: 200 * Devices.density
                fillMode: Image.PreserveAspectFit
            }

            BusyIndicator {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: isAndroidStyle? 36 * Devices.density : 24 * Devices.density
                Layout.preferredHeight: isAndroidStyle? 36 * Devices.density : 24 * Devices.density
                IOSStyle.foreground: "#fff"
                Material.accent: "#fff"
                opacity: 1 - initedNum
                running: opacity > 0
            }

            Label {
                Layout.topMargin: 14 * Devices.density
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Please Wait...") + Translations.refresher
                font.pixelSize: 9 * Devices.fontDensity
                color: "#fff"
                opacity: 1 - initedNum
            }
        }
    }
}
