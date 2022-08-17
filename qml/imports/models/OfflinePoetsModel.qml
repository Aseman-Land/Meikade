import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import Meikade 1.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    property bool cleanData: false

    Component.onCompleted: refresh()

    MeikadeOfflineItemGlobal {
        onOfflineRefreshed: refresh()
    }

    DataOfflinePoets {
        id: poetsReq
    }

    function refresh() {
        data = getList()
    }

    function getList() {
        var list = poetsReq.getItems();
        if (!cleanData)
            return list;

        var res = new Array;
        try {
            for (var j in list) {
                var d = list[j];
                var caps = Tools.stringRegExp(d.link, "^\\w+\\:\\/poet\\?id\\=(\\d+)$");
                if (caps.length === 0)
                    continue;

                var id = caps[0][1];
                if (id > 1000 && !Bootstrap.initialized)
                    continue;

                d["id"] = id;
                d["catId"] = 0;
                d["subtitle"] = GTranslations.translate(d.subtitle);
                d["image"] = Constants.thumbsBaseUrl + caps[0][1] + ".png";
                res[res.length] = d;
            }

        } catch (e) {
        }
        return res;
    }
}
