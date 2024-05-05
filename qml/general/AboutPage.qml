import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import models 1.0
import "views"

AboutView {
    id: dis
    qtVersion: qVersion
    applicationVersion: GTranslations.translate(AsemanApp.applicationVersion)
    headerBtn.onClicked: ViewportType.open = false
}


