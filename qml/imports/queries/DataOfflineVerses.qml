import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0

DataBaseQuery {
    id: obj
    table: "vorder"
    primaryKeys: ["poem_id", "vorder"]

    property int poem_id
    property int vorder
    property int position
    property string text
    property int poet

    function getItems() {
        var res = query("SELECT vorder, position, text FROM verse WHERE poem_id = :poem_id ORDER BY vorder",
                       {"poem_id": obj.poem_id});

        return {"result": res};
    }
}
