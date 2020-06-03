import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0
import globals 1.0

DataBaseQuery {
    id: obj

    property int poet_id

    function getItems(callback) {
        queryAsync("SELECT poet.name AS username, poet.name, poet.description, poet.wikipedia, " +
                   "poet.image, poet.color, poet.id, 0 AS views FROM poet WHERE poet.id = :poet_id ",
                   {"poet_id": poet_id}, function(res) {
                       if (res.length == 0) {
                           callback(res);
                           return;
                       }

                       queryAsync("SELECT cat.id, cat.text AS title, cat.poet_id FROM cat WHERE poet_id = :poet_id AND parent_id = 0",
                                  {"poet_id": poet_id}, function(cats) {
                                      var r = res[0];
                                      r["categories"] = cats;
                                      r["types"] = new Array;
                                      callback(r);
                                  })
                   });
    }
}
