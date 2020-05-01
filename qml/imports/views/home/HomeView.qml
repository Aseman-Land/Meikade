import QtQuick 2.12
import AsemanQml.Base 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import globals 1.0

HomeForm {
    id: homePage
    width: Constants.width
    height: Constants.height

    list.section.delegate: Item {
        id: sectionItem
        width: list.width
        height: text.length ? 40 * Devices.density : 0

        property string text: {
            var idx = section.indexOf(":")
            if (idx >= 0)
                return section.slice(0, idx)
            else
                return section
        }
        property string link: {
            var idx = section.indexOf(":")
            if (idx >= 0)
                return section.slice(idx+1)
            else
                return ""
        }

        Label {
            id: sectionTxt
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: list.spacing
            font.pixelSize: 10 * Devices.fontDensity
            text: sectionItem.text

            Button {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: sectionItem.link.length
                text: qsTr("More") + Translations.refresher
                flat: true
                font.pixelSize: 8 * Devices.fontDensity
                onClicked: homePage.linkRequest(sectionItem.link)
            }
        }
    }
}
