import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import Meikade 1.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    data: getItems()

    MeikadeOfflineItemGlobal {
        onOfflineInstalled: data = getItems()
    }

    DataOfflinePoets {
        id: poetsReq
    }

    function getItems() {
        var res = poetsReq.query("SELECT poet.name AS subtitle, offline.cat_id as CatId, offline.poet_id as id, cat.text AS title " +
                                 "FROM offline INNER JOIN cat ON offline.cat_id = cat.id INNER JOIN poet ON offline.poet_id = poet.id " +
                                 "WHERE offline.cat_id > 0");

        try {
            for (var i in res) {
                var d = res[i];
                d["image"] = Constants.thumbsBaseUrl + d.id + ".png";
            }
        } catch (e) {
        }
        return res;
    }
}
