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

    cancelBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: confirm()
    nameField.onAccepted: confirm()

    function confirm() {
        updateReq.networkManager.post(updateReq)
    }

    UserSetDetailsRequest {
        id: updateReq
        allowGlobalBusy: true
        name: home.nameField.text
        onSuccessfull: {
            home.ViewportType.open = false;
            GlobalSignals.snackbarRequest( qsTr("Name updated successfully") );
            MyUserRequest.refresh();
        }
    }
}
