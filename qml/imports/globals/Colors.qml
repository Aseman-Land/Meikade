pragma Singleton

import QtQuick 2.10
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import AsemanQml.Base 2.0

QtObject {
    property bool darkMode: false

    readonly property color primary: isAndroidStyle? Material.primary : IOSStyle.primary
    readonly property color accent: isAndroidStyle? Material.accent : IOSStyle.accent
    readonly property color background: isAndroidStyle? Material.background : IOSStyle.background
    readonly property color foreground: isAndroidStyle? Material.foreground : IOSStyle.foreground

    readonly property color headerText: "#ffffff"
    readonly property color header: primary

    readonly property color lightBackground: Qt.darker(background, (isAndroidStyle? (Material.theme == Material.Dark? 1 : 0.9) : (IOSStyle.theme == IOSStyle.Dark? 1 : 0.9)))
    readonly property color deepBackground: Qt.darker(background, (isAndroidStyle? (Material.theme == Material.Dark? 1.4 : 1.05) : (IOSStyle.theme == IOSStyle.Dark? 1.4 : 1.05)))
}
