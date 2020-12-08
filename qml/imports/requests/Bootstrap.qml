pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

AsemanObject {
    id: bstrap

    readonly property string configPath: AsemanApp.homePath + "/bootstrap.data"
    property bool initialized: false

    onInitializedChanged: {
        if (!initialized)
            return;

        var json = Tools.readText(configPath);
        var map = Tools.toVariantMap("{}");
        if (json.length)
            map = Tools.jsonToVariant(json);

        map.initialized = true;

        Tools.writeText(configPath, Tools.variantToJson(map));
    }

    Component.onCompleted: {
        var json = Tools.readText(configPath);
        var map = Tools.jsonToVariant(json);

        try {
            initialized = map.initialized;
        } catch (e) {
            initialized = false;
        }
    }

    BootstrapRequest {
        id: req
        _debug: true
        onSuccessfull: bstrap.initialized = response.result.initialized
    }

    function refresh() {
    }

    function init() {
        refresh()
    }
}
