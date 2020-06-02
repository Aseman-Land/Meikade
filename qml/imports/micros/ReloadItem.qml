import QtQuick 2.0
import AsemanQml.Base 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import globals 1.0

Item {
    width: layout.width
    height: layout.height
    z: 1000

    property Item viewItem

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: viewItem.model && viewItem.model.refreshing !== undefined && viewItem.model.refreshing && viewItem.count == 0
    }

    DelayPropertySwitch {
        id: delayProperty
        switchProperty: viewItem.model && viewItem.model.refreshing !== undefined && !viewItem.model.refreshing && viewItem.count == 0? true : false
        delay: 1000
    }

    ColumnLayout {
        id: layout
        visible: delayProperty.switchProperty && delayProperty.targetProperty

        Label {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 9 * Devices.fontDensity
            opacity: 0.6
            text: qsTr("Connection Error") + Translations.refresher
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 9 * Devices.fontDensity
            highlighted: true
            text: qsTr("Retry") + Translations.refresher
            onClicked: viewItem.model.refresh()
        }
    }
}
