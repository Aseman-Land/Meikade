pragma Singleton

import QtQuick 2.7
import AsemanQml.Base 2.0
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0

AsemanObject {
    readonly property string cachePath: AsemanApp.homePath + "/cache"

    property alias settings: _settings
    property alias languageInited: _settings.languageInited
    property alias language: _settings.language
    property alias phrase: _settings.phrase
    property alias introDone: _settings.introDone
    property alias sendData: _settings.sendData
    property alias iosTheme: _settings.iosTheme
    property alias androidTheme: _settings.androidTheme

    property alias accessToken: _auth.accessToken
    property alias uniqueId: _auth.uniqueId
    property alias lastSync: _auth.lastSync

    Component.onCompleted: {
        Tools.mkDir(cachePath)
    }

    Settings {
        id: _settings
        category: "General"
        source: AsemanApp.homePath + "/ui-settings.ini"

        property bool languageInited: false
        property string language: "fa"
        property bool phrase: true
        property bool introDone
        property bool sendData

        property int iosTheme: IOSStyle.System
        property int androidTheme: Material.Light
    }

    Settings {
        id: _auth
        category: "General"
        source: AsemanApp.homePath + "/auth.ini"

        property string accessToken
        property string uniqueId
        property string lastSync

        Component.onCompleted: {
            if (uniqueId.length == 0) uniqueId = Tools.createUuid()
        }
    }
}

