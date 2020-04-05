pragma Singleton

import QtQuick 2.7
import AsemanQml.Base 2.0
import QtQuick.Controls.Material 2.1
import MeikadeDesign 1.0

AsemanObject {
    Material.theme: darkMode? Material.Dark : Material.Light
    Material.accent: AsemanGlobals.primaryAccentColor

    readonly property string cachePath: AsemanApp.homePath + "/cache"

    readonly property bool darkMode: {
        switch (nightMode) {
        case 0: return false
        case 1: return true
        case 2: return (dateChecker.date.getHours() > 19 || dateChecker.date.getHours() < 6? true : false)
        }
    }

    readonly property int primary: {
        var theme = darkMode? darkColorTheme : colorTheme
        switch (theme) {
        case 1: return Material.Teal
        case 2: return Material.Orange
        default: return Material.Blue
        }
    }

    readonly property variant accent: {
        var theme = darkMode? darkColorTheme : colorTheme
        switch (theme) {
        case 2: return Material.Red
        default: return Material.color(Material.Cyan)
        }
    }

    readonly property color primaryHeaderColor: {
        var theme = darkMode? darkColorTheme : colorTheme
        switch (theme) {
        case 3: return Material.background
        default: return Qt.darker(Material.color(primary), darkMode? 1.8 : 1)
        }
    }

    readonly property color primaryTextColor: {
        var theme = darkMode? darkColorTheme : colorTheme
        switch (theme) {
        case 3: return Material.foreground
        default: return "#ffffff"
        }
    }

    property alias nightMode: _settings.nightMode
    property alias colorTheme: _settings.colorTheme
    property alias darkColorTheme: _settings.darkColorTheme
    property alias languageInited: _settings.languageInited

    property alias settings: _settings

    property alias accessToken: _auth.accessToken


    onPrimaryTextColorChanged: Constants.headerTextColor = primaryTextColor
    onPrimaryHeaderColorChanged: Constants.headerColor = primaryHeaderColor
    onDarkModeChanged: {
        Material.theme = darkMode? Material.Dark : Material.Light
        Constants.darkMode = darkMode
    }
    Component.onCompleted: {
        Constants.darkMode = darkMode
        Constants.headerTextColor = primaryTextColor
        Constants.headerColor = primaryHeaderColor

        Tools.mkDir(cachePath)
    }

    Timer {
        id: dateChecker
        interval: 60 * 1000
        triggeredOnStart: true
        repeat: true
        running: true
        onTriggered: date = new Date
        property date date: new Date
    }

    Settings {
        id: _settings
        category: "General"
        source: AsemanApp.homePath + "/ui-settings.ini"

        property bool languageInited: false
        property int nightMode: 0
        property int colorTheme: 0
        property int darkColorTheme: 3
    }

    Settings {
        id: _auth
        category: "General"
        source: AsemanApp.homePath + "/auth.ini"

        property string accessToken
    }
}

