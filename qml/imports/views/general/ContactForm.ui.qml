import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import micros 1.0
import models 1.0

Page {
    id: dis
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias headerItem: headerItem
    property alias closeBtn: closeBtn
    property alias nameField: nameField
    property alias emailField: emailField
    property alias messageField: messageField
    property alias attachSwitch: attachSwitch
    property alias detailsText: detailsText
    property alias sendBtn: sendBtn

    AsemanFlickable {
        id: flick
        anchors.top: tabBar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        flickableDirection: Flickable.VerticalFlick
        contentWidth: scene.width
        contentHeight: scene.height
        bottomMargin: Devices.navigationBarHeight
        visible: tabBar.currentIndex == 0
        clip: true

        EscapeItem {
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
                spacing: 0

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("Fee\ls free and write what you want for us. Messages will sends ananymously if you leaves name and email forms empty.") + Translations.refresher
                    Layout.bottomMargin: 10 * Devices.density
                }

                Label {
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: qsTr("Name") + ":" + Translations.refresher
                }

                TextField {
                    id: nameField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    validator: RegExpValidator { regExp: /(\w|\s)+/ }
                    Layout.bottomMargin: 10 * Devices.density
                }

                Label {
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: qsTr("Email") + ":" + Translations.refresher
                }

                TextField {
                    id: emailField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 * Devices.density
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    validator: RegExpValidator { regExp: /\w(\w|\.)+\@\w+(\.\w+)+/ }
                    Layout.bottomMargin: 10 * Devices.density
                }

                Label {
                    font.pixelSize: 9 * Devices.fontDensity
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: qsTr("Message") + ":" + Translations.refresher
                }

                TextArea {
                    id: messageField
                    Layout.fillWidth: true
                    Layout.minimumHeight: 100 * Devices.density
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 9 * Devices.fontDensity
                    Layout.bottomMargin: 10 * Devices.density
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    selectByMouse: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        text: qsTr("Attach device details") + Translations.refresher
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                    }

                    Switch {
                        id: attachSwitch
                    }
                }

                Label {
                    id: detailsText
                    Layout.fillWidth: true
                    font.pixelSize: 8 * Devices.fontDensity
                    opacity: attachSwitch.checked? 0.8 : 0.3
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    text: "Device details: test"
                    Layout.bottomMargin: 10 * Devices.density
                }

                Label {
                    Layout.fillWidth: true
                    font.pixelSize: 8 * Devices.fontDensity
                    text: (attachSwitch.checked? qsTr("Device details will send.") : qsTr("Device details will not sent. Please send it if you are reporting a problem.")) + Translations.refresher
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: attachSwitch.checked? "#18f" : "#a00"
                }

                Button {
                    id: sendBtn
                    Layout.fillWidth: true
                    font.pixelSize: 9 * Devices.fontDensity
                    highlighted: true
                    enabled: messageField.length > 10
                    text: qsTr("Send") + Translations.refresher
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
        visible: flick.visible
    }

    AsemanListView {
        id: listView
        anchors.top: tabBar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        visible: tabBar.currentIndex == 1
        model: 20
        clip: true
        delegate: Item {
            width: listView.width
            height: mainRow.height + 10 * Devices.density

            RowLayout {
                id: mainRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10 * Devices.density
                y: 5 * Devices.density
                spacing: 10 * Devices.density

                Rectangle {
                    Layout.alignment: Qt.AlignTop
                    Layout.topMargin: 6 * Devices.density
                    Layout.preferredHeight: 40 * Devices.density
                    Layout.preferredWidth: 40 * Devices.density
                    radius: 6 * Devices.density
                    color: Colors.primary

                    Label {
                        anchors.centerIn: parent
                        font.pixelSize: 16 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_bug
                        color: "#fff"
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4 * Devices.density

                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 9 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        text: "عنوان تستی"
                    }

                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 8 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        elide: Text.ElideRight
                        text: "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است. چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است و برای شرایط فعلی تکنولوژی مورد نیاز و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد. کتابهای زیادی در شصت و سه درصد گذشته، حال و آینده شناخت فراوان جامعه و متخصصان را می طلبد تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی و فرهنگ پیشرو در زبان فارسی ایجاد کرد."
                    }

                    RowLayout {
                        Label {
                            Layout.fillWidth: true
                            font.pixelSize: 8 * Devices.fontDensity
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            elide: Text.ElideRight
                            opacity: 0.7
                            text: GTranslations.translate( CalendarConv.convertDateTimeToString(new Date) )
                        }

                        Button {
                            id: voteBtn
                            flat: true
                            Layout.preferredWidth: voteRow.width + 8 * Devices.density

                            RowLayout {
                                id: voteRow
                                x: 4 * Devices.density
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 8 * Devices.density

                                Label {
                                    font.pixelSize: 10 * Devices.fontDensity
                                    font.family: MaterialIcons.family
                                    text: MaterialIcons.mdi_thumb_up
                                    opacity: 0.6
                                }

                                Label {
                                    font.pixelSize: 8 * Devices.fontDensity
                                    text: "۱۰۰ نفر"
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1 * Devices.density
                color: Colors.foreground
                opacity: 0.1
            }
        }
    }

    HScrollBar {
        scrollArea: listView
        anchors.top: listView.top
        anchors.bottom: listView.bottom
        anchors.right: listView.right
        color: Colors.primary
        visible: listView.visible
    }

    TabBar {
        id: tabBar
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        TabButton {
            text: qsTr("Send Message") + Translations.refresher
            font.pixelSize: 8 * Devices.fontDensity
        }

        TabButton {
            text: qsTr("User's Requests") + Translations.refresher
            font.pixelSize: 8 * Devices.fontDensity
        }
    }

    Header {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        text: qsTr("Contact us") + Translations.refresher
        color: Colors.headerColor
        light: !Colors.lightHeader
        shadow: Devices.isAndroid

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 14 * Devices.density
            anchors.rightMargin: 2 * Devices.density
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            RoundButton {
                id: closeBtn
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                text: qsTr("Close") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.accent: Qt.darker(Colors.primary, 1.3)
                Material.accent: Qt.darker(Colors.primary, 1.3)
                Material.theme: Material.Dark
                Material.elevation: 0
            }
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
