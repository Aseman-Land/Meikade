import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import globals 1.0

ChangeNameView {
    id: home
    width: Math.min(Viewport.viewport.width * 0.9, 500*Devices.density)
    height: 230 * Devices.density

    nameField.horizontalAlignment: Text.AlignLeft

    cancelBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: confirm()
    nameField.onAccepted: confirm()

    headerLabel.text: qsTr("Change Bio") + Translations.refresher
    description: qsTr("Please enter new biography:") + Translations.refresher
    nameField.placeholderText: qsTr("Biography") + Translations.refresher

    function confirm() {
        updateReq.networkManager.post(updateReq)
    }

    UserSetDetailsRequest {
        id: updateReq
        allowGlobalBusy: true
        bio: home.nameField.text
        onSuccessfull: {
            home.ViewportType.open = false;
            GlobalSignals.snackbarRequest( qsTr("Bio updated successfully") );
            MyUserRequest.refresh();
        }
    }
}
