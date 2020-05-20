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
}
