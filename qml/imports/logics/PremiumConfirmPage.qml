import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import queries 1.0
import globals 1.0

PremiumConfirmView {
    id: home
    width: Viewport.viewport.width
    height: 400 * Devices.density

    cancelBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: confirm()

    titleLabel.text: GTranslations.translate( qsTr("%1 Tomans per Month").arg("4,000") )
    subtitleLabel.text: GTranslations.translate( qsTr("%1 Tomans per Year").arg("40,000") )

    function confirm() {
        home.ViewportType.open = false;
    }
}
