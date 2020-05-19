import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0

DataBaseQuery {
    id: obj
    table: "General"
    primaryKeys: ["key"]

    property string key
    property string value
}
