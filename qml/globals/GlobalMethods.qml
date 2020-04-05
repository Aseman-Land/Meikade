pragma Singleton

import QtQuick 2.7
import QtQuick.Controls 2.0
import AsemanQml.Base 2.0

AsemanObject {
    function showError(title, message) {
        GlobalObjects.errorDialog.title = title
        GlobalObjects.errorDialog.message = message
        GlobalObjects.errorDialog.open()
    }
}
