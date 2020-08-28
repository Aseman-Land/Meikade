import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0
import globals 1.0

DataBaseQuery {
    id: obj

    property string query
    property variant poets: new Array

    property int offset: 0
    property int limit: 50

    function getItems(callback) {
        if (query.length == 0) {
            callback(new Array);
            return;
        }

        var poetsQuery = "";
        poets.forEach(function(r){
            if (poetsQuery.length)
                poetsQuery += " OR "
            poetsQuery += ("verse.poet = " + r)
        })
        if (poetsQuery.length)
            poetsQuery = " (" + poetsQuery + ") AND "

        queryAsync("SELECT poem.id AS poem__id, poem.cat_id AS poem__category_id, poem.title AS poem__title, " +
                   "0 AS poem__views, poet.id AS poet__id, poet.name AS poet__username, " +
                   "poet.name AS poet__name, 0 AS poet__views, cat.id AS categories__id, " +
                   "cat.text AS categories__title, parentCat.id AS categories2__id, parentCat.text AS categories2__title," +
                   "verse.vorder AS verses__vorder, verse.position AS verses__position, verse.text AS verses__text, " +
                   "verse2.vorder AS verses2__vorder, verse2.position AS verses2__position, verse2.text AS verses2__text FROM verse " +
                   "INNER JOIN poet ON verse.poet = poet.id " +
                   "INNER JOIN poem ON verse.poem_id = poem.id " +
                   "INNER JOIN cat ON poem.cat_id = cat.id " +
                   "LEFT OUTER JOIN cat AS parentCat ON cat.parent_id = parentCat.id " +
                   "LEFT OUTER JOIN verse AS verse2 ON verse2.poem_id = verse.poem_id AND " +
                   "((verse2.vorder % 2 == 0 AND verse2.vorder = verse.vorder + 1) OR " +
                   "(verse2.vorder % 2 <> 0 AND verse2.vorder = verse.vorder - 1)) " +
                   "WHERE " + poetsQuery + " verse.text LIKE :keyword LIMIT :limit OFFSET :offset",
                   {"keyword": "%" + query + "%", "limit": limit, "offset": offset}, callback);
    }
}
