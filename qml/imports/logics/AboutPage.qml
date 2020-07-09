import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import views 1.0
import models 1.0

AboutView {
    id: dis
    qtVersion: qVersion
    headerBtn.onClicked: ViewportType.open = false
}
