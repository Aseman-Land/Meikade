pragma Singleton

import QtQuick 2.7
import AsemanQml.Base 2.0
import QtQuick.Controls.Material 2.1
import globals 1.0

AsemanObject {
    readonly property string cachePath: AsemanApp.homePath + "/cache"
    property alias languageInited: _settings.languageInited
    property alias language: _settings.language

    property alias settings: _settings
    property alias accessToken: _auth.accessToken

    Component.onCompleted: {
        Tools.mkDir(cachePath)
    }

    Settings {
        id: _settings
        category: "General"
        source: AsemanApp.homePath + "/ui-settings.ini"

        property bool languageInited: false
        property string language: "fa"
    }

    Settings {
        id: _auth
        category: "General"
        source: AsemanApp.homePath + "/auth.ini"

        property string accessToken
    }
}

