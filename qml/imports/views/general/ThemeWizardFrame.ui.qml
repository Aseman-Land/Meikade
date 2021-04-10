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

ColumnLayout {
    spacing: 0
    clip: true

    property alias listView: listView

    Label {
        Layout.fillWidth: true
        Layout.topMargin: 8 * Devices.density
        font.pixelSize: 9 * Devices.fontDensity
        text: qsTr("Please select theme") + Translations.refresher
        horizontalAlignment: Text.AlignHCenter
    }

    Item {
        Layout.fillWidth: true
        Layout.topMargin: 8 * Devices.density
        Layout.preferredHeight: 12 * Devices.density
        clip: true

        Rectangle {
            width: 15 * Devices.density
            height: width
            rotation: 45
            color: Colors.accent
            anchors.verticalCenter: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        orientation: ListView.Horizontal

        LayoutMirroring.enabled: false
        LayoutMirroring.childrenInherit: true

        model: ThemesModel {}
        leftMargin: (width - listView.height * 0.6)/2
        rightMargin: leftMargin
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 250
        snapMode: ListView.SnapOneItem
        preferredHighlightBegin: leftMargin
        preferredHighlightEnd: width - rightMargin
        delegate: ItemDelegate {
            width: height * 0.6
            height: listView.height
            onClicked: listView.currentIndex = model.index

            Image {
                anchors.fill: parent
                anchors.topMargin: 20 * Devices.density
                anchors.bottomMargin: 20 * Devices.density
                source: model.image
                fillMode: Image.PreserveAspectFit
                sourceSize.width: width * 1.2
                sourceSize.height: height * 1.2
                asynchronous: true
            }
        }
    }
}
