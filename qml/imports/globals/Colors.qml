pragma Singleton

import QtQuick 2.10
import QtQuick.Controls.Material 2.0
import AsemanQml.Base 2.0
import Meikade 1.0

QtObject {
    Material.theme: AsemanGlobals.androidEffectiveTheme

    Component.onCompleted: MeikadeTools.setupWindowColor(headerColor)
    onHeaderColorChanged: MeikadeTools.setupWindowColor(headerColor)

    readonly property bool darkMode: (background.r + background.g + background.b) / 3 < 0.5? true : false

    readonly property bool androidStyle: {
        try {
            return isAndroidStyle;
        } catch(e) {
            return false;
        }
    }

    readonly property bool lightHeader: AsemanGlobals.mixedHeaderColor && !darkMode
    readonly property color headerColor: AsemanGlobals.mixedHeaderColor? lightBackground : primary
    readonly property color headerTextColor: AsemanGlobals.mixedHeaderColor? foreground : "#fff"
    readonly property color primary: Material.primary
    readonly property color accent: "#0d80ec"
    readonly property color background: Material.background
    readonly property color foreground: Material.foreground

    readonly property color noteButton: "#4caf50"

    readonly property color lightBackground: Qt.darker(background, (Material.theme == Material.Dark? 0.9 : 0.9))
    readonly property color deepBackground: Qt.darker(background, (Material.theme == Material.Dark? 1.4 : 1.05))
}
