import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0

DataBaseQuery {
    id: obj
    table: "cat"
    primaryKeys: ["id"]

    property int id
    property int poet_id
    property string text
    property int parent_id
    property string url

    function getItems(offset, limit) {
        var items = new Array;
        var poemsCount = 0;
        var catsCount = 0;

        var analize = function(data, poemQuery) {
            for (var i in data)
            {
                var d = data[i];
                var item = {
                    "color": "",
                    "details": null,
                    "heightRatio": 0.6,
                    "image": "",
                    "link": "stack:/poet?id=" + d.poet_id + (poemQuery? "&poemId=" : "&catId=") + d.id,
                    "subtitle": d.poemsCount + " poems",
                    "title": d.text,
                    "type": "fullback",
                    "details": {
                        "first_verse": d.first_verse
                    }
                };

                items[items.length] = item;
            }

            if (poemQuery)
                poemsCount = items.length;
            else
                catsCount = items.length;
        }

        analize( query("SELECT cat.id, cat.poet_id, cat.text, COUNT(poem.id) as poemsCount " +
                       "FROM cat LEFT OUTER JOIN poem ON cat.id = poem.cat_id " +
                       "WHERE cat.poet_id = :poet_id AND cat.parent_id = :cat_id " +
                       " GROUP BY cat.id LIMIT :limit OFFSET :offset",
                       {"poet_id": obj.poet_id, "cat_id": obj.parent_id, "offset": offset, "limit": limit}), false);

        analize( query("SELECT id, " + obj.poet_id + " as poet_id, title as text, 0 as poemsCount, verse.text as first_verse " +
                       "FROM poem LEFT OUTER JOIN verse ON poem.id = verse.poem_id AND vorder = 1 " +
                       "WHERE cat_id = :cat_id GROUP BY poem.id LIMIT :limit OFFSET :offset",
                       {"cat_id": obj.parent_id, "offset": offset, "limit": limit}), true);


        var resItem = {
            "background": false,
            "color": "transparent",
            "section": "",
            "type": obj.parent_id == 0? "grid" : "column",
            "modelData": items,
            "offlineResult": true,
            "offset": offset
        };

        var length = resItem.modelData.length;
        for (var j=0; j<length; j++) {
            var d = resItem.modelData[j];
            d["moreHint"] = (j === (length - 20));
        }

        return resItem;
    }
}
