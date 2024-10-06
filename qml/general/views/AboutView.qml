import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.0
import globals 1.0
import components 1.0
import requests 1.0
import "privates"

MPage {
    width: Constants.width
    height: Constants.height

    property alias headerBtn: headerBtn
    property string qtVersion: "5.15.0"
    property string applicationVersion: "4.2.0"

    AsemanFlickable {
        id: flick
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        contentHeight: flickScene.height
        contentWidth: flickScene.width
        bottomMargin: Devices.navigationBarHeight

        Item {
            id: flickScene
            width: flick.width
            height: Math.max(flickColumn.height + 40 * Devices.density, flick.height)

            ColumnLayout {
                id: flickColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 20 * Devices.density
                spacing: 20 * Devices.density

                Image {
                    Layout.fillWidth: true
                    horizontalAlignment: Image.AlignHCenter
                    Layout.preferredHeight: 92 * Devices.density
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: 160 * Devices.density
                    sourceSize.height: 160 * Devices.density
                    source: "qrc:/qml/images/views/meikade.png"
                }

                MLabel {
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignJustify
                    textFormat: Text.StyledText
                    text: qsTr("<b><u>Meikade is a free and opensource poetry app</u></b>, designed and created by Aseman. It means user freedom and privacy is important for Meikade. So you can access Meikade's source code on Github, Read it and change it under the term of the GPLv3 license.") + Translations.refresher
                }

                MLabel {
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("Version:") + " " + applicationVersion
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 0

                    Repeater {
                        model: ListModel {
                            ListElement {
                                title: qsTr("Website")
                                link: "https://meikade.com"
                                icon: "mdi_web"
                            }
                            ListElement {
                                title: qsTr("Instagram")
                                link: "https://instagram.com/meikadeapp/"
                                icon: "mdi_instagram"
                            }
                            ListElement {
                                title: qsTr("Telegram")
                                link: "https://t.me/meikadeapp"
                                icon: "mdi_telegram"
                            }
                            ListElement {
                                title: qsTr("Github")
                                link: "https://github.com/Aseman-Land/Meikade"
                                icon: "mdi_git"
                            }
                        }

                        MButton {
                            id: mkd_iconBtn
                            Layout.preferredWidth: 42 * Devices.density
                            flat: true
                            font.pixelSize: 20 * Devices.fontDensity
                            font.family: MaterialIcons.family
                            text: MaterialIcons[model.icon]

                            Connections {
                                target: mkd_iconBtn
                                onClicked: Viewport.controller.trigger("float:/web?link=" + model.link)
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 4 * Devices.density

                    MLabel {
                        font.pixelSize: 9 * Devices.fontDensity
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Development Team:") + Translations.refresher
                    }

                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Aseman") + Translations.refresher
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4 * Devices.density

                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft
                        text: qsTr("Thanks to:") + Translations.refresher
                    }

                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        horizontalAlignment: Text.AlignJustify
                        text: qsTr("Hamidreza Mohammad (Ganjoor team), Arman Farajollahi-far, Purya Daneshvar (UI/UX), Armin Shalchian (Apple Watch), Amin Hatami (Logo Designer), Mohsen Ebrahimnejad (Telegram channel assistant), Hasan Noroozi, Houtan Baraary, Mansoore Zamani, Pourya Khalaj Tehrani") + Translations.refresher
                    }
                }

                Image {
                    Layout.fillWidth: true
                    Layout.topMargin: 20 * Devices.density
                    horizontalAlignment: Image.AlignHCenter
                    Layout.preferredHeight: 92 * Devices.density
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: 160 * Devices.density
                    sourceSize.height: 160 * Devices.density
                    source: "qrc:/qml/images/views/aseman.png"
                    visible: Bootstrap.aseman
                }

                MLabel {
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignJustify
                    textFormat: Text.StyledText
                    text: qsTr("<b><u>Aseman</u></b>, Aseman is a non-profit and community based company that created in 2013 by members of the Idehgostar company. Aseman created to leads open-source and free software.<br />Aseman promotes openness, innovation and participation on the digital and computers world.") + Translations.refresher
                    visible: Bootstrap.aseman
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 0
                    visible: Bootstrap.aseman

                    Repeater {
                        model: ListModel {
                            ListElement {
                                title: qsTr("Website")
                                link: "https://aseman.io"
                                icon: "mdi_web"
                            }
                            ListElement {
                                title: qsTr("Instagram")
                                link: "https://instagram.com/asemanland/"
                                icon: "mdi_instagram"
                            }
                            ListElement {
                                title: qsTr("Telegram")
                                link: "https://t.me/asemanland"
                                icon: "mdi_telegram"
                            }
                            ListElement {
                                title: qsTr("Twitter")
                                link: "https://twitter.com/asemanland"
                                icon: "mdi_twitter"
                            }
                            ListElement {
                                title: qsTr("Github")
                                link: "https://github.com/Aseman-Land/"
                                icon: "mdi_git"
                            }
                        }

                        MButton {
                            Layout.preferredWidth: 42 * Devices.density
                            flat: true
                            font.pixelSize: 20 * Devices.fontDensity
                            font.family: MaterialIcons.family
                            text: MaterialIcons[model.icon]

                            Connections {
                                onClicked: Viewport.controller.trigger("float:/web?link=" + model.link)
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    MLabel {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        text: qsTr("Open-source projects used in meikade:") + Translations.refresher
                    }

                    Repeater {
                        model: AsemanListModel {
                            data: [
                                {"title": "QtAseman", "license": "GNU GPL v3", "link": "https://github.com/Aseman-Land/QtAseman/", "description": qsTr("Some tools, creating for Aseman Qt projects and used on many of Aseman's projects.")},
                                {"title": "Ganjoor", "license": "GNU GPL v2", "link": "http://ganjoor.net", "description": qsTr("Persian poetry web site called ganjoor which includes a .NET based Windows client and a SQLite copy of site database.")},
                                {"title": "Qt Framework " + qtVersion, "license": "GNU GPL v3", "link": "http://qt.io", "description": qsTr("Qt is a cross-platform application and UI framework for developers using C++ or QML, a CSS & JavaScript like language.")},
                            ]
                        }

                        MItemDelegate {
                            id: osDel
                            Layout.fillWidth: true
                            Layout.preferredHeight: osAppColumn.height + 20 * Devices.density

                            Connections {
                                target: osDel
                                onClicked: Viewport.controller.trigger("float:/web?link=" + model.link)
                            }

                            ColumnLayout {
                                id: osAppColumn
                                anchors.left: parent.left
                                anchors.right: parent.right
                                y: 10 * Devices.density
                                anchors.margins: 10 * Devices.density
                                spacing: 4 * Devices.density

                                MLabel {
                                    Layout.fillWidth: true
                                    font.pixelSize: 9 * Devices.fontDensity
                                    horizontalAlignment: Text.AlignLeft
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    text: model.title
                                }

                                MLabel {
                                    Layout.fillWidth: true
                                    font.pixelSize: 8 * Devices.fontDensity
                                    horizontalAlignment: Text.AlignJustify
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    text: model.description
                                }

                                MLabel {
                                    Layout.fillWidth: true
                                    font.pixelSize: 8 * Devices.fontDensity
                                    horizontalAlignment: Text.AlignLeft
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    text: model.link
                                    color: Colors.accent
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    HScrollBar {
        scrollArea: flick
        anchors.right: flick.right
        anchors.top: flick.top
        anchors.bottom: flick.bottom
        color: Colors.primary
    }

    header: MHeader {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        title: qsTr("About") + Translations.refresher

        HeaderBackButton {
            id: headerBtn
            color: Colors.headerTextColor
        }
    }
}

