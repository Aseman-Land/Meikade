import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0

UserBaseQuery {
    id: obj
    table: "general"
    primaryKeys: ["_key"]

    property string _key
    property string _value
}
