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
    property alias fontSize: _settings.fontSize
    property alias onlineSearch: _settings.onlineSearch
    property alias introDone: _settings.introDone
    property alias sendData: _settings.sendData
    property alias iosTheme: _settings.iosTheme
    property alias androidTheme: _settings.androidTheme

    property alias accessToken: _auth.accessToken
    property alias username: _auth.username
    property alias uniqueId: _auth.uniqueId

    property alias lastSync: _sync.lastSync
    property alias syncFavorites: _sync.syncFavorites
    property alias syncViews: _sync.syncViews
    property alias syncTopPoets: _sync.syncTopPoets

    Component.onCompleted: {
        Tools.mkDir(cachePath);
    }

    onAccessTokenChanged: {
        if (initTimer.running)
            return;

        if (accessToken.length) {
            lastSync = "";
            syncFavorites = false;
            syncViews = false;
            syncTopPoets = false;
        }
    }

    Timer {
        id: initTimer
        interval: 100
        repeat: false
        running: true
    }

    Settings {
        id: _settings
        category: "General"
        source: AsemanApp.homePath + "/ui-settings.ini"

        property bool languageInited: false
        property string language: "fa"
        property bool phrase: true
        property bool onlineSearch: true
        property bool introDone
        property bool sendData
        property int fontSize: 3

        property int iosTheme: 2
        property int androidTheme: 0
    }

    Settings {
        id: _auth
        category: "General"
        source: AsemanApp.homePath + "/auth.ini"

        property string username
        property string accessToken
        property string uniqueId

        Component.onCompleted: {
            if (uniqueId.length == 0) uniqueId = Tools.createUuid()
        }
    }

    Settings {
        id: _sync
        category: "General"
        source: AsemanApp.homePath + "/sync.ini"

        property string lastSync
        property bool syncFavorites: false
        property bool syncViews: false
        property bool syncTopPoets: false
    }
}

