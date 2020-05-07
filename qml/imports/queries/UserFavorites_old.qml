import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0

UserBaseQuery {
    id: obj
    table: "favorites"
    primaryKeys: ["poem_id", "vorder"]

    property int poem_id
    property int vorder
    property string text
}
