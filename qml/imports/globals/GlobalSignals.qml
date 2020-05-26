pragma Singleton

import QtQuick 2.10

QtObject {
    signal recentPoemsRefreshed();

    signal snackbarRequest(string text)
}
