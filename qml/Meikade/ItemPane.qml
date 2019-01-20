import QtQuick 2.0
import QtQuick.Controls 2.1
import AsemanQml.Base 2.0
import QtQuick.Controls.Material 2.1
import "globals"

Pane {
//    color: MeikadeGlobals.backgroundAlternativeColor
//    radius: 3*Devices.density
//    shadowColor: "#88000000"
    padding: 0
    Material.elevation: MeikadeGlobals.iosStyle? 0*Devices.density : 1*Devices.density
}
