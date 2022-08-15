import QtQuick 2.9
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Controls 2.3
import globals 1.0

HeaderMenuButton {
    id: btn
    ratio: 1
    x: iosPopup? (LayoutMirroring.enabled? 0 : parent.width - width) : (LayoutMirroring.enabled? parent.width - width : 0)
    buttonColor: iosPopup? "transparent" : color
    color: iosPopup? Colors.headerTextColor : Colors.foreground

    Label {
        anchors.centerIn: parent
        text: MaterialIcons.mdi_close
        font.family: MaterialIcons.family
        font.pixelSize: 14 * Devices.fontDensity
        color: btn.color
        visible: btn.iosPopup
    }

    property bool iosPopup

    Component.onCompleted: {
        var obj = this;
        while (obj) {
            if (obj.isIOSPopup) {
                iosPopup = true;
                break;
            }
            obj = obj.parent;
        }
    }
}
