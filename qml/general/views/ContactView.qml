import QtQuick 2.14
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
import requests 1.0
import "privates"

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
    property alias suggestionsModel: listView.model

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
        visible: tabBar.currentIndex == 1
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
                    text: qsTr("Feels free and write what you want for us. Messages will sends ananymously if you leaves name and email forms empty.") + Translations.refresher
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
                    validator: RegularExpressionValidator { regularExpression: /(\w|\s)+/ }
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
                    validator: RegularExpressionValidator { regularExpression: /\w(\w|\.)+\@\w+(\.\w+)+/ }
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

    BusyIndicator {
        anchors.centerIn: parent
        visible: listView.visible
        running: sugModel.refreshing && listView.count == 0
    }

    AsemanListView {
        id: listView
        anchors.top: tabBar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        visible: tabBar.currentIndex == 0
        clip: true
        model: SuggestionsModel { id: sugModel }

        header: Item {
            width: listView.width
            height: descLbl.height + 20 * Devices.density

            Label {
                id: descLbl
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10 * Devices.density
                y: 10 * Devices.density
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("Features that suggested by Meikade users. You can rate them.") + Translations.refresher
                font.pixelSize: 8 * Devices.fontDensity
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

        delegate: Item {
            id: sugItem
            width: listView.width
            height: mainRow.height + 10 * Devices.density

            property int inited: 0
            property bool voted: model.user.vote
            property int votesCount: model.votes_count

            Component.onCompleted: inited++

            Connections {
                onInitedChanged: {
                    let date = Tools.dateFromSec( Math.floor(Date.parse(model.created_at) / 1000) );
                    sugDate.text = GTranslations.translate( CalendarConv.convertDateTimeToString(date) );
                    sugPeoples.text = GTranslations.translate( qsTr("%1 people").arg(sugItem.votesCount) );
                }
            }

            VoteSuggestionRequest {
                id: voteReq
                _suggestion_id: model.id

                Connections {
                    onSuccessfull: sugModel.refresh()
                }
            }

            UnvoteSuggestionRequest {
                id: unvoteReq
                _suggestion_id: model.id

                Connections {
                    onSuccessfull: sugModel.refresh()
                }
            }

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
                    color: model.extra.color

                    Label {
                        anchors.centerIn: parent
                        font.pixelSize: 16 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons[model.extra.icon]
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
                        text: model.title
                    }

                    Label {
                        Layout.fillWidth: true
                        font.pixelSize: 8 * Devices.fontDensity
                        horizontalAlignment: Text.AlignLeft
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        elide: Text.ElideRight
                        text: model.description
                    }

                    RowLayout {
                        Label {
                            id: sugDate
                            Layout.fillWidth: true
                            font.pixelSize: 8 * Devices.fontDensity
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            elide: Text.ElideRight
                            opacity: 0.7
                        }

                        Button {
                            id: voteBtn
                            flat: true
                            Layout.preferredWidth: voteRow.width + 8 * Devices.density

                            Connections {
                                onClicked: {
                                    if (model.status == 1)
                                        return;

                                    sugItem.voted = !sugItem.voted;
                                    sugItem.votesCount += (sugItem.voted? 1 : -1);
                                    sugItem.inited++;
                                    if (model.user.vote)
                                        unvoteReq.doRequest();
                                    else
                                        voteReq.doRequest();
                                }
                            }

                            BusyIndicator {
                                id: busyIndicator
                                scale: 0.6
                                anchors.centerIn: parent
                                height: 28 * Devices.density
                                width: 28 * Devices.density
                                Material.accent: Colors.primary
                                IOSStyle.foreground: Colors.primary
                                running: unvoteReq.refreshing || voteReq.refreshing
                            }

                            RowLayout {
                                id: voteRow
                                x: 4 * Devices.density
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 8 * Devices.density
                                visible: !busyIndicator.running

                                Label {
                                    font.pixelSize: 10 * Devices.fontDensity
                                    font.family: MaterialIcons.family
                                    text: model.status == 1? MaterialIcons.mdi_check : MaterialIcons.mdi_thumb_up
                                    opacity: sugItem.voted? 1 : 0.6
                                    color: model.status == 1? "#00aa00" : sugItem.voted? Colors.primary : Colors.foreground
                                }

                                Label {
                                    id: sugPeoples
                                    font.pixelSize: 8 * Devices.fontDensity
                                    opacity: 1
                                    color: model.status == 1? "#00aa00" : sugItem.voted? Colors.primary : Colors.foreground
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
            text: qsTr("User's Requests") + Translations.refresher
            font.pixelSize: 8 * Devices.fontDensity
        }

        TabButton {
            text: qsTr("Send Message") + Translations.refresher
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
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
                IOSStyle.foreground: Colors.foreground
                IOSStyle.background: Colors.deepBackground
                Material.foreground: Colors.foreground
                Material.background: Colors.deepBackground
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

