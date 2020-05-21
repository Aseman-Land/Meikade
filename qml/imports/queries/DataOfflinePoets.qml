import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0

DataBaseQuery {
    id: obj

    function getItems() {
        var items = new Array;

        var analize = function(data) {
            for (var i in data)
            {
                var d = data[i];
                var item = {
                    "color": "",
                    "details": null,
                    "heightRatio": 1,
                    "image": "",
                    "link": "page:/poet?id=" + d.id,
                    "subtitle": qsTr("%1 books").arg(d.catCount),
                    "title": d.name,
                    "type": "normal"
                };

                items[items.length] = item;
            }
        }

        analize( query("SELECT poet.name, poet.cat_id, poet.description, poet.id, COUNT(cat.id) as catCount FROM offline " +
                       "INNER JOIN poet ON offline.poet_id = poet.id " +
                       "INNER JOIN cat ON offline.poet_id = cat.poet_id AND cat.parent_id = 0 " +
                       "WHERE offline.cat_id = 0 GROUP BY offline.poet_id", {}) );

        return items;
    }
}
