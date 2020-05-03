import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Network 2.0
import globals 1.0
import routes 1.0

NetworkRequest {
    id: req
    contentType: 0//NetworkRequest.TypeJson
    ignoreRegExp: /_\w+/
    headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + AsemanGlobals.accessToken,
        "Accept-Language": "fa"
    }

    readonly property string baseUrl: "https://api.meikade.com/api"
    readonly property bool refreshingState: req.refreshing
    property bool allowGlobalBusy: false

    property alias _networkManager: networkManager
    property bool _debug: false

    signal refreshRequest()

    onResponseChanged: if (_debug) console.debug(Tools.variantToJson(response))
    onHeadersChanged: if (!refreshing) refreshRequest()
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
        Tools.jsDelayCall(500, function() {
            ViewController.trigger("dialog:/general/error", {"title": title, "body": body})
        })
    }

    NetworkRequestManager {
        id: networkManager
    }

    Timer {
        repeat: false
        running: true
        interval: 100
        onTriggered: refreshRequest()
    }
}
