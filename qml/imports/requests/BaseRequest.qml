import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Network 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import routes 1.0

NetworkRequest {
    id: req
    contentType: NetworkRequest.TypeJson
    ignoreKeys: ["baseUrl", "refreshingState", "allowGlobalBusy", "networkManager", "allowShowErrors", "rawHeaders", "accessToken"]
    ignoreRegExp: /^_\w+$/
    headers: rawHeaders
    ignoreSslErrors: AsemanGlobals.ignoreSslErrors

    readonly property variant rawHeaders: {
        "Unique-ID": AsemanGlobals.uniqueId,
        "App-Name": AsemanApp.applicationName,
        "App-ID": AsemanApp.applicationId,
        "App-Version": AsemanApp.applicationVersion,
        "App-Build-OS": (Devices.isAndroid? "android" : Devices.isIOS? "ios" : Devices.isLinux? "linux" : Devices.isWindows? "windows" : Devices.isMacX? "osx" : "other"),
        "Theme-Dark": Colors.darkMode? "true" : "false",
        "Content-Type": "application/json",
        "Premium-Days": AsemanGlobals.lastPremiumDays + "",
        "User-token": accessToken,
        "Accept-Language": GTranslations.localeName,
    }

    property string accessToken: AsemanGlobals.accessToken
    readonly property string baseUrl: "https://api.meikade.com/api"
    readonly property bool refreshingState: req.refreshing
    property bool allowGlobalBusy: false
    property bool allowShowErrors: true

    property alias networkManager: networkManager
    property bool _debug: false

    signal refreshRequest()

    onIgnoreSslErrorsChanged: if (!refreshing) refreshTimer.restart()
    onStatusChanged: if (status == 401 && AsemanGlobals.accessToken.length && accessToken == AsemanGlobals.accessToken) { AsemanGlobals.accessToken = ""; ViewController.trigger("float:/auth/float"); }
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

    onSslErrorsChanged: {
        if (AsemanGlobals.ignoreSslErrorsViewed)
            return;

        var dlg = ViewController.trigger("dialog:/general/error", {"title": qsTr("SSL Error"), "body": qsTr("You have connection security issue:%1Do you want to ignore it?").arg("\n" + sslErrors.trim() + "\n"), "buttons": [qsTr("Yes"), qsTr("No")]})
        dlg.itemClicked.connect(function(index){
            if (index == 0)
                AsemanGlobals.ignoreSslErrors = true;

            dlg.Viewport.viewport.closeLast();
        })
        AsemanGlobals.ignoreSslErrorsViewed = true;
    }
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
