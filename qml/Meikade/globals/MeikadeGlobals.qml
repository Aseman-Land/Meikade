pragma Singleton

import QtQuick 2.7
import AsemanQml.Base 2.0
import QtQuick.Controls.Material 2.1

AsemanObject {
    property color masterColor: "#881010"
    property color alternativeColor: Material.color(Material.Cyan)
    property color backgroundColor: Material.background
    property color backgroundAlternativeColor: Qt.lighter(Material.background)
    property color foregroundColor: Material.foreground

    Material.theme: Meikade.nightTheme? Material.Dark : Material.Light
    Material.background: Meikade.nightTheme? "#313131" : "#eaeaea"

    property alias categoriesList: _categoriesList
    property string profilePath: AsemanApp.homePath

    property alias darkMode: settings.darkMode
    property alias execCount: settings.execCount
    property alias localeName: settings.localeName
    property alias lastCheckedVersion: settings.lastCheckedVersion
    property alias lastUpdateCheckedVersion: settings.lastUpdateCheckedVersion
    property alias languageSelected: settings.languageSelected

    property alias translator: translationManager

    ListObject {
        id: _categoriesList
    }

    Settings {
        id: settings
        source: profilePath + "/settings.ini"
        category: "General"

        property bool darkMode: false
        property string localeName: "en"
        property bool languageSelected: false
        property int execCount: 0
        property string lastCheckedVersion
        property string lastUpdateCheckedVersion
    }

    TranslationManager {
        id: translationManager
        sourceDirectory: Devices.resourcePath + "/files/translations"
        delimiters: "-"
        fileName: "lang"
        localeName: settings.localeName

        function refreshLayouts() {
            View.layoutDirection = textDirection
        }
        Component.onCompleted: refreshLayouts()
        onLocaleNameChanged: refreshLayouts()
    }
}

