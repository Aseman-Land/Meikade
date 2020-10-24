import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import Meikade 1.0
import globals 1.0
import routes 1.0

MeikadeOfflineItem {
    sourceUrl: Constants.offlinesUrl
    databasePath: AsemanApp.homePath + "/database.sqlite"

    function checkAndInstall(active) {
        var cnt = checkCount();
        if (!active || cnt < Premium.listsLimits) {
            install(active);
            return true;
        } else {
            var errorInputs = {
                "title": qsTr("Premium Needed"),
                "body": qsTr("Your limit %1 offline poets ended. Do you want to buy premium account?").arg(Premium.offlineLimits),
                "buttons": [
                    qsTr("Cancel"),
                    qsTr("BUY Premium")
                ]
            };
            var err = ViewController.trigger("dialog:/general/error", errorInputs);
            err.itemClicked.connect(function(index){
                console.debug(index);
                err.ViewportType.open = false;
            });
            return false;
        }
    }
}
