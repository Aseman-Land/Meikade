pragma Singleton

import QtQuick 2.10
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import AsemanQml.Base 2.0

QtObject {
    IOSStyle.theme: AsemanGlobals.iosTheme
    Material.theme: AsemanGlobals.androidTheme

    readonly property bool darkMode: (background.r + background.g + background.b) / 3 < 0.5? true : false

    readonly property bool androidStyle: {
        try {
            return isAndroidStyle;
        } catch(e) {
            return false;
        }
    }

    readonly property color primary: androidStyle? Material.primary : IOSStyle.primary
    readonly property color accent: androidStyle? Material.accent : IOSStyle.accent
    readonly property color background: androidStyle? Material.background : IOSStyle.background
    readonly property color foreground: androidStyle? Material.foreground : IOSStyle.foreground

    readonly property color noteButton: "#4caf50"

    readonly property color headerText: "#ffffff"
    readonly property color header: primary

    readonly property color lightBackground: Qt.darker(background, (androidStyle? (Material.theme == Material.Dark? 0.9 : 0.9) : (IOSStyle.theme == IOSStyle.Dark? 0.9 : 0.9)))
    readonly property color deepBackground: Qt.darker(background, (androidStyle? (Material.theme == Material.Dark? 1.4 : 1.05) : (IOSStyle.theme == IOSStyle.Dark? 1.4 : 1.05)))
}
