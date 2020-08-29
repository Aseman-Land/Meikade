import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0
import globals 1.0

UserBaseQuery {
    id: obj
    table: "actions"
    primaryKeys: ["poetId", "catId", "poemId", "verseId", "type"]

    property int poetId
    property int catId
    property int poemId
    property int verseId
    property int type
    property int declined
    property string value
    property string extra
    property int updatedAt
    property int synced

    enum Types {
        TypeUnknown = 0,
        TypeFavorite = 1,
        TypeNote = 2,
        TypePoetViewDate = 3,
        TypeCatViewDate = 4,
        TypePoemViewDate = 5,
        TypeTopPoets = 6,
        TypeListCreate = 7,
        TypeItemListsStart = 1000000000,
        TypeItemListsEnd = 2000000000
    }

    function getItems(type, offset, limit) {
        return select("", "type = :type AND declined = 0", "ORDER BY updatedAt DESC LIMIT :limit OFFSET :offset", {type: type, offset: offset, limit: limit})
    }

    function getLists() {
        var res = new Array;
        var list = select("", "(type = :favType OR type > :type) AND poetId = :poetId AND catId = :catId AND " +
                          "poemId = :poemId AND verseId = :verseId AND declined = 0", "ORDER BY value",
                          {favType: UserActions.TypeFavorite, type: UserActions.TypeItemListsStart, poetId: poetId,
                           catId: catId, poemId: poemId, verseId: verseId});
        list.forEach(function(l){
            if (l.type >= UserActions.TypeItemListsEnd)
                return;

            res[res.length] = l.type;
        })
        return res;
    }

    function pushAction() {
        updatedAt = Tools.dateToSec(new Date);
        synced = 0;
        push();
        GlobalSignals.syncRequest();
    }
}
