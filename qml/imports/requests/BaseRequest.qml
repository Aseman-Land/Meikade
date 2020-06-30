import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Network 2.0
import globals 1.0
import routes 1.0

NetworkRequest {
    id: req
    contentType: NetworkRequest.TypeJson
    ignoreKeys: ["baseUrl", "refreshingState", "allowGlobalBusy", "networkManager", "allowShowErrors"]
    ignoreRegExp: /^_\w+$/
    headers: {
        "Unique-ID": AsemanGlobals.uniqueId,
        "App-Name": AsemanApp.applicationName,
        "App-Version": AsemanApp.applicationVersion,
        "App-Build-OS": (Devices.isAndroid? "android" : Devices.isIOS? "ios" : Devices.isLinux? "linux" : Devices.isWindows? "windows" : Devices.isMacX? "osx" : "other"),
        "Theme-Dark": Colors.darkMode? "true" : "false",
        "Content-Type": "application/json",
        "User-token": AsemanGlobals.accessToken,
        "Accept-Language": GTranslations.localeName
    }

    readonly property string baseUrl: "https://api.meikade.com/api"
    readonly property bool refreshingState: req.refreshing
    property bool allowGlobalBusy: false
    property bool allowShowErrors: true

    property alias networkManager: networkManager
    property bool _debug: false

    signal refreshRequest()

    onResponseChanged: if (_debug) console.debug(Tools.variantToJson(response))
    onHeadersChanged: if (!refreshing) refreshTimer.restart()
    onRefreshingStateChanged: {
        if (!allowGlobalBusy)
            return;

        if (refreshingState)
            ViewController.waitCount++
        else
            ViewController.waitCount--
    }

    Component.onDestruction: if (refreshingState && allowGlobalBusy) ViewController.waitCount--

    onServerError: {
        try {
            _showError("Server Error", response.message)
        } catch (e) {}
    }
    onClientError: {
        try {
            _showError("Client Error", response.message);
        } catch (e) {}
    }

    function _showError(title, body) {
        if (!allowShowErrors)
            return;

        Tools.jsDelayCall(500, function() {
            ViewController.trigger("dialog:/general/error", {"title": title, "body": body})
        })
    }

    NetworkRequestManager {
        id: networkManager
    }

    Timer {
        id: refreshTimer
        repeat: false
        running: true
        interval: 100
        onTriggered: refreshRequest()
    }
}
