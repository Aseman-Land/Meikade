pragma Singleton

import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0

AsemanObject {
    id: obj

    UserGeneral {
        id: general
        _key: "version"
    }

    UserFavorites_old {
        id: favorites
    }

    UserNotes_old {
        id: notes
    }

    function init() {
        update(0);
        general.fetch();
        switch (general._value * 1) {
        case 0:
            update(1);
            importFavorites();
            break;
        }
    }

    function update(version) {
        if (version > 0) {
            console.debug("Userdb updating to:", version)
            general._value = version;
            general.push();
        }

        general.createQuery = Tools.readText( Tools.urlToLocalPath( Qt.resolvedUrl("sql/userdata_" + version + ".sql") ) );
        general.create();
    }

    function importFavorites() {
        console.debug("Updating data...");
        var dataDb = dataDb_component.createObject(this);
        var favList = favorites.query("SELECT * FROM favorites");

        general.begin();
        favList.forEach( function(fav) {
            var res = dataDb.query("SELECT poet.name AS poet_name, poet.id AS poet_id, poem.title AS poem_title FROM poem " +
                                   "LEFT JOIN cat ON poem.cat_id = cat.id LEFT JOIN poet ON cat.poet_id = poet.id WHERE poem.id = :poem_id LIMIT 1",
                                   {"poem_id": fav.poem_id});

            var vorderRes = dataDb.query("SELECT text FROM verse WHERE poem_id = :poem_id AND vorder = :vorder",
                                         {"vorder": (fav.vorder? fav.vorder : 1), "poem_id": fav.poem_id});

            try {
                var r = res[0];
                var item = {
                    image: "https://meikade.com/offlines/thumbs/" + r.poet_id + ".png",
                    link:"page:/poet?id=" + r.poet_id + "&poemId=" + fav.poem_id,
                    subtitle: r.poet_name,
                    title: r.poem_title,
                    verseText: vorderRes[0].text
                }

                var date = Math.floor(fav.date/1000);
                var extra = Tools.variantToJson(item);

                general.query("INSERT INTO actions (poetId, catId, poemId, verseId, type, declined, value, extra, updatedAt, synced) " +
                              "VALUES (:poet_id, 0, :poem_id, :vorder, 1, 0, 0, :extra, :date, 0)",
                              {"poet_id": r.poet_id, "poem_id": fav.poem_id, "vorder": fav.vorder, "date": date, "extra": extra})
            } catch (e) {}
        })

        general.commit();
        console.debug("Done :)");
    }

    Component {
        id: dataDb_component
        SqlObject {
            driver: SqlObject.SQLite
            databaseName: AsemanApp.homePath + "/data.sqlite"
        }
    }
}
