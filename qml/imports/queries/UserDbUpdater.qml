pragma Singleton

import QtQuick 2.12
import AsemanQml.Base 2.0

AsemanObject {
    id: obj

    UserGeneral {
        id: general
        _key: "version"
    }

    UserFavorites_old {
        id: favorites
    }

    UserNotes_old {
        id: notes
    }

    function init() {
        update(0)
        general.fetch()
        switch (general._value * 1) {
        case 0:
            update(1)
            break;
        }
    }

    function update(version) {
        if (version > 0) {
            console.debug("Userdb updating to:", version)
            general._value = version
            general.push()
        }

        general.createQuery = Tools.readText( Tools.urlToLocalPath( Qt.resolvedUrl("sql/userdata_" + version + ".sql") ) )
        general.create();
    }
}
