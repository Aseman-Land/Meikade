import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0
import globals 1.0

DataBaseQuery {
    id: obj

    property int poem_id

    function random(poetId, catId, callback) {
        queryAsync("SELECT poem.id AS poem_id FROM poem " +
                   (catId || poetId? "LEFT JOIN cat ON poem.cat_id = cat.id " + (catId? " AND cat.id = :catId " : "") : "") +
                   (poetId? "LEFT JOIN poet ON cat.poet_id = poet.id AND poet.id = :poetId " : "") +
                   "ORDER BY RANDOM() LIMIT 1", {"poetId": poetId, "catId": catId}, function(res){
            _getItems(res[0].poem_id, callback);
        });
    }

    function getItems(callback, offset, limit) {
        _getItems(poem_id, callback, offset, limit);
    }

    function _getItems(poem_id, callback, offset, limit) {
        if (offset === undefined)
            offset = 0;
        if (limit === undefined)
            limit = 100;

        queryAsync("SELECT poem.id AS poem_id, poem.title AS poem_title, poem.phrase AS poem_phrase, cat.text AS cat_title, cat.id AS cat_id, cat.parent_id AS cat_parent, " +
                   "poet.name AS poet_name, poet.description AS poet_description, poet.wikipedia AS poet_wikipedia, poet.image AS poet_image, " +
                   "poet.color AS poet_color, poet.id AS poet_id, poem.cat_id AS poem_category_id, cat.poet_id AS poem_poet_id, " +
                   "cat2.id AS cat2_id, cat2.text AS cat2_title " +
                   "FROM poem " +
                   "LEFT JOIN cat ON poem.cat_id = cat.id " +
                   "LEFT JOIN poet ON cat.poet_id = poet.id " +
                   "LEFT OUTER JOIN cat AS cat2 ON cat.parent_id = cat2.id " +
                   "WHERE poem.id = :poem_id",
                   {"poem_id": poem_id}, function(res) {
                       if (res.length == 0) {
                           callback(res, offset, limit);
                           return;
                       }

                       var r = res[0];
                       var unit = {
                           poem: {
                               id: r.poem_id,
                               poet_id: r.poem_poet_id,
                               category_id: r.poem_category_id,
                               title: r.poem_title,
                               phrase: r.poem_phrase,
                               views: 0
                           },
                           categories: [
                               {
                                   id: r.cat_id,
                                   title: r.cat_title
                               }
                           ],
                           poet: {
                               id: r.poet_id,
                               username: r.poet_name,
                               name: r.poet_name,
                               description: r.poet_description,
                               image: r.poet_image,
                               wikipedia: r.poet_wikipedia,
                               color: r.poet_color,
                               views: 0
                           }
                       }

                       if (r.cat2_id) {
                           unit.categories[unit.categories.length] = {
                               id: r.cat2_id,
                               title: r.cat2_title
                           }
                       }

                       queryAsync("SELECT vorder, position, text FROM verse WHERE poem_id = :poem_id LIMIT :limit OFFSET :offset",
                                  {"poem_id": poem_id, "limit": limit, "offset": offset}, function(verses) {
                                      unit["verses"] = verses;
                                      callback(unit, offset, limit);
                                  })
                   });
    }
}
