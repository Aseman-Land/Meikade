import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import views 1.0
import models 1.0

ContactView {
    id: dis
    closeBtn.onClicked: ViewportType.open = false

    detailsText.textFormat: Text.RichText
    detailsText.text: {
        var res = "";
        res += "<b>" + qsTr("Platform Name") + ":</b> " + Devices.platformName + "<br />";
        res += "<b>" +qsTr("Kernel") + ":</b> " + Devices.platformKernel + " " + Devices.platformKernelVersion + "<br />";
        res += "<b>" +qsTr("CPU Architecture") + ":</b> " + Devices.platformCpuArchitecture + "<br />";
        res += "<b>" +qsTr("Device Name") + ":</b> " + Devices.deviceName + "<br />";
//        res += "<b>" +qsTr("Device ID") + ":</b> " + Devices.deviceId + "<br />";
        res += "<b>" +qsTr("LCD Density") + ":</b> " + Math.floor(Devices.deviceDensity*100)/100 + "<br />";
        res += "<b>" +qsTr("LCD Size") + ":</b> " + Math.floor(Devices.lcdPhysicalSize*100)/100;
        return res;
    }
}
