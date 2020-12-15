pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

AsemanObject {
    id: bstrap

    readonly property string configPath: AsemanApp.homePath + "/bootstrap.data"

    property bool initialized: false
    property bool subscription: true
    property bool payment: false

    onInitializedChanged: write("initialized", initialized);
    onSubscriptionChanged: write("subscription", subscription);
    onPaymentChanged: write("payment", payment);

    Component.onCompleted: {
        read("initialized");
//        read("subscription");
        read("payment");
    }

    BootstrapRequest {
        id: req
        onSuccessfull: {
            try { bstrap.initialized = response.result.initialized } catch (e) {}
            try { bstrap.subscription = response.result.subscription } catch (e) {}
            try { bstrap.payment = response.result.payment } catch (e) {}
        }
    }

    function read(key) {
        var json = Tools.readText(configPath);
        var map = Tools.jsonToVariant(json);

        try {
            bstrap[key] = map[key];
        } catch (e) {
            bstrap[key] = false;
        }
    }

    function write(key, value) {
        if (!value)
            return;

        var json = Tools.readText(configPath);
        var map = Tools.toVariantMap("{}");
        if (json.length)
            map = Tools.jsonToVariant(json);

        map[key] = true;

        Tools.writeText(configPath, Tools.variantToJson(map));
    }

    function refresh() {
    }

    function init() {
        refresh()
    }
}
