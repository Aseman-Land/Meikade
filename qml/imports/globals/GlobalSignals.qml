pragma Singleton

import QtQuick 2.10

QtObject {
    signal recentPoemsRefreshed()
    signal topPoetsRefreshed()
    signal favoritesRefreshed()
    signal listsRefreshed()
    signal notesRefreshed()

    signal snackbarRequest(string text)
    signal syncRequest()
    signal reinitSync(variant controller)
}
