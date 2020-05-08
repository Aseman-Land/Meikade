pragma Singleton
import QtQuick 2.10
import QtQuick.Controls.Material 2.0
import AsemanQml.Base 2.0

QtObject {
    readonly property int width: 480
    readonly property int height: 800

    readonly property real spacing: 16 * Devices.density
    readonly property real radius: 10 * Devices.density

    readonly property string passwordSalt: "65ae7da2-acce-470e-9243-73fccd363ddc"

    function hashPassword(pass) {
        return Tools.hash(passwordSalt + pass + passwordSalt, Tools.Sha256);
    }
}
