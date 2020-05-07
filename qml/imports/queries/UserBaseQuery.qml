import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Sql 2.0

SqlObject {
    id: obj
    driver: SqlObject.SQLite
    databaseName: "/home/bardia/userdata.sqlite"

    function begin() { query("BEGIN", {}); }
    function commit() { query("COMMIT", {}); }
}
