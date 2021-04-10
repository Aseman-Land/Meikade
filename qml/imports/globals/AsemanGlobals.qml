pragma Singleton

import QtQuick 2.7
import AsemanQml.Base 2.0
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0

AsemanObject {
    readonly property string cachePath: AsemanApp.homePath + "/cache"

    property bool testHomeDisable: false
    property bool testSearchDisable: false
    property bool testMyMeikadeDisable: false
    property bool testIntroDisable: false
    property bool testPoetImagesDisable: false
    property bool testHeaderImagesDisable: false
    property bool testLogoDisable: false

    property alias settings: _settings
    property alias disablePremiumListsWarn: _settings.disablePremiumListsWarn
    property alias disablePremiumMyBooksWarn: _settings.disablePremiumMyBooksWarn
    property alias disablePremiumNotesWarn: _settings.disablePremiumNotesWarn
    property alias disablePremiumOfflinesWarn: _settings.disablePremiumOfflinesWarn
    property alias languageInited: _settings.languageInited
    property alias language: _settings.language
    property alias phrase: _settings.phrase
    property alias phraseNumber: _settings.phraseNumber
    property alias fontSize: _settings.fontSize
    property alias lastChangelogs: _settings.lastChangelogs
    property alias onlineSearch: _settings.onlineSearch
    property alias smartSearch: _settings.smartSearch
//    property bool introDone: false
    property alias introDone: _settings.introDone
    property alias themeDone: _settings.themeDone
    property alias sendData: _settings.sendData
    property alias iosTheme: _settings.iosTheme
    property alias androidTheme: _settings.androidTheme
    property alias width: _settings.width
    property alias height: _settings.height
    property alias mixedHeaderColor: _settings.mixedHeaderColor

    property alias accessToken: _auth.accessToken
    property alias username: _auth.username
    property alias uniqueId: _auth.uniqueId

    property alias lastSync: _sync.lastSync
    property alias syncFavorites: _sync.syncFavorites
    property alias syncMyPoems: _sync.syncMyPoems
    property alias syncNotes: _sync.syncNotes
    property alias syncViews: _sync.syncViews
    property alias syncTopPoets: _sync.syncTopPoets

    property int lastPremiumDays: -1

    Component.onCompleted: {
        Tools.mkDir(cachePath);

        if (mixedHeaderColor == -1)
            mixedHeaderColor = Devices.isIOS? 1 : 0
    }

    onAccessTokenChanged: {
        if (initTimer.running)
            return;

        if (accessToken.length) {
            lastSync = "";
            syncMyPoems = false;
            syncFavorites = false;
            syncViews = false;
            syncTopPoets = false;
            syncNotes = false;
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

        property bool disablePremiumListsWarn: false
        property bool disablePremiumNotesWarn: false
        property bool disablePremiumOfflinesWarn: false
        property bool disablePremiumMyBooksWarn: false

        property bool languageInited: false
        property string language: "fa"
        property bool phrase: true
        property bool phraseNumber: true
        property bool onlineSearch: true
        property bool smartSearch: true
        property bool introDone
        property bool themeDone
        property bool sendData
        property int fontSize: 3
        property int lastChangelogs: 0

        property int iosTheme: 2
        property int androidTheme: 0

        property int width: 1280
        property int height: 700
        property int mixedHeaderColor: -1
    }

    Settings {
        id: _auth
        category: "General"
        source: AsemanApp.homePath + "/auth.ini"

        property string username
        property string accessToken
        property string uniqueId

        Component.onCompleted: {
            if (uniqueId.length != 0)
                return;

            uniqueId = Tools.createUuid();
            _settings.language = Devices.isIOS? "en" : "fa";
        }
    }

    Settings {
        id: _sync
        category: "General"
        source: AsemanApp.homePath + "/sync.ini"

        property string lastSync
        property bool syncFavorites: false
        property bool syncNotes: false
        property bool syncViews: false
        property bool syncTopPoets: false
        property bool syncMyPoems: false
    }
}

