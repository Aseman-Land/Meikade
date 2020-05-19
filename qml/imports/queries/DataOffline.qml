import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0

DataBaseQuery {
    id: obj
    table: "offline"
    primaryKeys: ["poet_id", "cat_id"]

    property int poet_id
    property int cat_id
    property int state
}
