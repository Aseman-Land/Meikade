import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0

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
        TypeTopPoets = 6
    }

    function getItems(type, offset, limit) {
        return select("", "type = :type", "ORDER BY updatedAt DESC LIMIT :limit OFFSET :offset", {type: type, offset: offset, limit: limit})
    }
}
