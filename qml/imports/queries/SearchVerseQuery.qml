import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0
import globals 1.0

DataBaseQuery {
    id: obj

    function getItems(keyword, callback) {
        queryAsync("SELECT *  FROM verse INNER JOIN poet ON verse.poet = poet.id " +
                   "INNER JOIN poem ON verse.poem_id = poem.id INNER JOIN cat ON poem.cat_id = cat.id " +
                   "LEFT OUTER JOIN verse AS verse2 ON verse2.poem_id = verse.poem_id AND " +
                   "((verse2.vorder % 2 == 0 AND verse2.vorder = verse.vorder + 1) OR " +
                   "(verse2.vorder % 2 <> 0 AND verse2.vorder = verse.vorder -1)) WHERE verse.text LIKE :keyword", {"keyword": "%" + keyword + "%"}, callback);
    }
}
