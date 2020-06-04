import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0
import globals 1.0

DataBaseQuery {
    id: obj

    property int poem_id

    function getItems(callback) {
        queryAsync("SELECT poem.id AS poem_id, poem.title AS poem_title, cat.text AS cat_title, cat.id AS cat_id, cat.parent_id AS cat_parent, " +
                   "poet.name AS poet_name, poet.description AS poet_description, poet.wikipedia AS poet_wikipedia, poet.image AS poet_image, " +
                   "poet.color AS poet_color, poet.id AS poet_id, poem.cat_id AS poem_category_id, cat.poet_id AS poem_poet_id, " +
                   "cat2.id AS cat2_id, cat2.text AS cat2_title " +
                   "FROM poem " +
                   "INNER JOIN cat ON poem.cat_id = cat.id " +
                   "INNER JOIN poet ON cat.poet_id = poet.id " +
                   "LEFT OUTER JOIN cat AS cat2 ON cat.parent_id = cat2.id " +
                   "WHERE poem.id = :poem_id",
                   {"poem_id": poem_id}, function(res) {
                       if (res.length == 0) {
                           callback(res);
                           return;
                       }

                       var r = res[0];
                       var unit = {
                           poem: {
                               id: r.poem_id,
                               poet_id: r.poem_poet_id,
                               category_id: r.poem_category_id,
                               title: r.poem_title,
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

                       queryAsync("SELECT vorder, position, text FROM verse WHERE poem_id = :poem_id",
                                  {"poem_id": poem_id}, function(verses) {
                                      unit["verses"] = verses;
                                      callback(unit);
                                  })
                   });
    }
}
