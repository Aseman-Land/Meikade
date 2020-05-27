pragma Singleton

import QtQuick 2.10

QtObject {
    signal recentPoemsRefreshed()
    signal topPoetsRefreshed()

    signal snackbarRequest(string text)
}
