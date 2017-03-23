pragma Singleton

import QtQuick 2.7
import AsemanTools 1.1
import QtQuick.Controls.Material 2.1

AsemanObject {
    property color masterColor: "#881010"
    property color alternativeColor: Material.color(Material.Cyan)
    property color backgroundColor: Material.background
    property color backgroundAlternativeColor: Qt.lighter(Material.background)
    property color foregroundColor: Material.foreground

    Material.theme: Meikade.nightTheme? Material.Dark : Material.Light

    property alias categoriesList: _categoriesList

    ListObject {
        id: _categoriesList
    }
}

