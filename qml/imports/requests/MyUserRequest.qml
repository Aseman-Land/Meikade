pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

UserRequest {
    id: myUserReq

    readonly property string _cachePath: AsemanGlobals.cachePath + "/userinfo.json"
    property variant _cache

    readonly property string _username: {
        try {
            return _cache.username
        } catch (e) {
            return "";
        }
    }
    readonly property string _email: {
        try {
            return _cache.details.email
        } catch (e) {
            return "";
        }
    }
    readonly property string _fullname: {
        try {
            return _cache.details.name
        } catch (e) {
            return "";
        }
    }
    readonly property string _bio: {
        try {
            return _cache.details.bio;
        } catch (e) {
            return "";
        }
    }
    readonly property string _image: {
        try {
            return _cache.image;
        } catch (e) {
            return "";
        }
    }
    readonly property variant _subscription: {
        if (AsemanGlobals.accessToken.length == 0)
            return new Array;
        try {
            return _cache.subscriptions[0];
        } catch (e) {
            return new Array;
        }
    }

    Component.onCompleted: readCache();
    onRefreshRequest: refresh()
    onResponseChanged: {
        storeCache();
        readCache();
    }

    function refresh() {
        if (refreshing || AsemanGlobals.accessToken.length == 0)
            return;

        networkManager.get(myUserReq);
    }

    function storeCache() {
        var json = Tools.variantToJson(response);
        if (json.length === 0 && AsemanGlobals.accessToken.length)
            return;

        Tools.writeText(_cachePath, json);
    }

    function readCache() {
        var json = Tools.readText(_cachePath);
        if (json.length === 0)
            return;

        _cache = Tools.jsonToVariant(json);
    }

    function init() {}
}
