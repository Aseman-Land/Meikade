import QtQuick 2.0
import QtQuick.Controls 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.MaterialIcons 2.0
import models 1.0
import views 1.0
import micros 1.0
import requests 1.0
import globals 1.0

MyMeikadeView {
    id: dis

    Component.onCompleted: Tools.jsDelayCall(100, gridView.positionViewAtBeginning)

    signedIn: AsemanGlobals.accessToken.length

    gridView.model: MyMeikadeModel {}

    settingsBtn.onClicked: Viewport.controller.trigger("page:/settings")
    onClicked: {
        if (link == "float:/syncs" && AsemanGlobals.accessToken.length == 0)
            link = "float:/auth/float";

        Viewport.controller.trigger(link, {})
    }

    profileLabel.text: MyUserRequest._fullname
    authBtn.onClicked: Viewport.controller.trigger("float:/auth/float", {})

    avatarBtn.onClicked: {
        var pos = Qt.point(avatarBtn.width/2, avatarBtn.height);
        var parent = avatarBtn;
        while (parent && parent != dis) {
            pos.x += parent.x;
            pos.y += parent.y;
            parent = parent.parent;
        }

        Viewport.viewport.append(menuComponent, {"pointPad": pos}, "menu");
    }

    UserUploadProfileRequest {
        id: uploadReq
        allowGlobalBusy: true
        onSuccessfull: {
            console.debug(Tools.variantToJson(response))
        }
    }

    Connections {
        target: Devices
        onSelectImageResult: {
            uploadReq.file = Devices.localFilesPrePath + path
            uploadReq.networkManager.post(uploadReq)
        }
    }

    Component {
        id: menuComponent
        MenuView {
            id: menuItem
            x: pointPad.x - width/2
            y: Math.min(pointPad.y, dis.height - height - 100 * Devices.density)
            width: 220 * Devices.density
            ViewportType.transformOrigin: {
                var y = 0;
                var x = width/2;
                return Qt.point(x, y);
            }

            property point pointPad
            property int index

            onItemClicked: {
                switch (index) {
                case 0:
                    Viewport.controller.trigger("bottomdrawer:/auth/changeName");
                    break;
                case 1:
                    Devices.getOpenPictures();
                    break;
                case 2:
                    Viewport.controller.trigger("float:/auth/changePassword", {"forgetMode": false});
                    break;
                }

                ViewportType.open = false;
            }

            model: AsemanListModel {
                data: [
                    {
                        title: qsTr("Change Name"),
                        icon: "mdi_account",
                        enabled: true
                    },
                    {
                        title: qsTr("Change Avatar"),
                        icon: "mdi_face_profile",
                        enabled: false
                    },
                    {
                        title: qsTr("Change Password"),
                        icon: "mdi_textbox_password",
                        enabled: true
                    },
                ]
            }
        }
    }
}
