pragma Singleton

import QtQuick 2.12
import AsemanQml.Base 2.0

AsemanObject {
    id: obj

    DataGeneral {
        id: general
        key: "Database/version"
    }

    function init() {
        update(0)
        general.fetch()
        switch (general.value * 1) {
        case 0:
            update(1);
            update(2);
            break;

        case 1:
            update(2);
            break;

        case 2:
            update(3);
            break;
        }
    }

    function update(version) {
        if (version > 0) {
            console.debug("Datadb updating to:", version)
            general.value = version
            general.push()
        }

        general.createQuery = Tools.readText( Tools.urlToLocalPath( Qt.resolvedUrl("sql/data_" + version + ".sql") ) )
        general.create();
    }
}
