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
        TypeItemBooksStart = 896999999,
        TypeItemBooksEnd = 996999999,
        TypeItemViewDiaryStart = 997000000,
        TypeItemViewDiaryEnd = 999999999,
        TypeItemListsStart = 1000000000,
        TypeItemListsEnd = 2000000000
    }

    function getItems(type, offset, limit) {
        return select("", "type = :type AND declined = 0", "ORDER BY updatedAt DESC LIMIT :limit OFFSET :offset", {type: type, offset: offset, limit: limit})
    }

    function getFavedPoets() {
        return select("", "type = :type AND declined = 0", "GROUP BY poetId", {type: UserActions.TypeFavorite})
    }

    function getPoemAttributes() {
        var list =  select("", "poetId = :poetId AND poemId = :poemId AND (type = :fav OR type = :note OR (type > :listStart AND type < :listEnd)) AND declined = 0", "",
                           {poetId: poetId, poemId: poemId, fav: UserActions.TypeFavorite, note: UserActions.TypeNote,
                            listStart: UserActions.TypeItemListsStart, listEnd: UserActions.TypeItemListsEnd});

        var res = Tools.toVariantMap("");
        list.forEach(function(l){
            var row = res[l.verseId];
            row = Tools.toVariantMap(row);
            if (l.type > UserActions.TypeItemListsStart && l.type < UserActions.TypeItemListsEnd)
                row[UserActions.TypeItemListsStart] = true;
            else
                row[l.type] = true;

            res[l.verseId] = row;
        })
        return res;
    }

    function getDiaries(fromDate) {
        var startHour = Math.floor(Tools.dateToSec(new Date(2020, 1, 1)) / 3600);
        var currentHour = Math.floor(Tools.dateToSec(fromDate) / 3600);

        var type = UserActions.TypeItemViewDiaryStart + (currentHour - startHour);
        if (type < UserActions.TypeItemViewDiaryStart || type >= UserActions.TypeItemViewDiaryEnd)
            return new Array;

        var list = select("", "(type < :endType AND type >= :fromType) AND declined = 0",
                          {fromType: type, endType: UserActions.TypeItemViewDiaryEnd});
        return list;
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

    function getBooks() {
        var list = select("", "(type < :typeEnd AND type > :typeStart) AND poetId = :poetId AND catId = :catId AND " +
                          "poemId = :poemId AND verseId = :verseId AND declined = 0", "ORDER BY value",
                          {typeEnd: UserActions.TypeItemBooksEnd, typeStart: UserActions.TypeItemBooksStart, poetId: poetId,
                           catId: catId, poemId: poemId, verseId: verseId});
        return list;
    }

    function pushAction() {
        updatedAt = Tools.dateToSec(new Date);
        synced = 0;
        push();
        GlobalSignals.syncRequest();
    }
}
