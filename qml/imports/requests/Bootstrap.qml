pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

AsemanObject {
    id: bstrap

    readonly property string configPath: AsemanApp.homePath + "/bootstrap.data"

    property bool initialized: false
    property bool subscription: false
    property bool payment: false
    property bool aseman: false
    property bool fullyUnlocked: false

    readonly property string paymentUnlockCode: try { return req.response.result.paymentUnlockCode; } catch (e) { return ""; }

    onInitializedChanged: write("initialized", initialized);
    onSubscriptionChanged: write("subscription", subscription);
    onPaymentChanged: write("payment", payment);
    onAsemanChanged: write("aseman", aseman);
    onFullyUnlockedChanged: write("fullyUnlocked", fullyUnlocked);

    Component.onCompleted: {
        read("initialized");
        read("subscription");
        read("payment");
        read("aseman");
        read("fullyUnlocked");
    }

    BootstrapRequest {
        id: req
        onSuccessfull: {
            try { if (!bstrap.initialized) bstrap.initialized = response.result.initialized } catch (e) {}
            try { if (!bstrap.subscription) bstrap.subscription = response.result.subscription } catch (e) {}
            try { if (!bstrap.payment) bstrap.payment = response.result.payment } catch (e) {}
            try { if (!bstrap.aseman) bstrap.aseman = response.result.aseman } catch (e) {}
            try { if (!bstrap.fullyUnlocked) bstrap.fullyUnlocked = response.result.fullyUnlocked } catch (e) {}
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
