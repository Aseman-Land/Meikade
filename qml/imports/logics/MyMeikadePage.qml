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
import queries 1.0
import globals 1.0

MyMeikadeView {
    id: dis

    Component.onCompleted: {
        Tools.jsDelayCall(100, gridView.positionViewAtBeginning);
        refreshDiaries();
    }

    signedIn: AsemanGlobals.accessToken.length

    gridView.model: MyMeikadeModel {}

    settingsBtn.onClicked: Viewport.controller.trigger("page:/settings")
    onClicked: {
        if (link == "float:/syncs" && AsemanGlobals.accessToken.length == 0)
            link = "float:/auth/float";

        Viewport.controller.trigger(link, {});
    }

    avatar.header: MyUserRequest.headers
    avatar.source: MyUserRequest._image
    bioLabel.text: MyUserRequest._bio
    profileLabel.text: MyUserRequest._fullname
    authBtn.onClicked: Viewport.controller.trigger("float:/auth/float", {})
    messagesBtn.onClicked: Viewport.controller.trigger("float:/inbox", {})

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

    function refreshDiaries() {
        ActivityManager.reload();
        dailyDiary.numberLabel.text = Tools.trNums(ActivityManager.daily);
        weeklyDiary.numberLabel.text = Tools.trNums(ActivityManager.weekly);
        favesDiary.numberLabel.text = Tools.trNums(ActivityManager.faves);
    }

    onVisibleChanged: {
        if (visible)
            refreshDiaries();
    }

    UserSetProfileRequest {
        id: setProfilePicReq
        allowGlobalBusy: true
        onSuccessfull: MyUserRequest.refresh();
    }

    UserUploadProfileRequest {
        id: uploadReq
        allowGlobalBusy: true
        onSuccessfull: {
            setProfilePicReq._image = response.file;
            setProfilePicReq.doRequest();
        }
    }

    Connections {
        target: Devices
        onSelectImageResult: {
            let p = Devices.localFilesPrePath + path;
            let size = Tools.imageSize(p);
            let ratio = size.width / size.height;

            let img = AsemanGlobals.cachePath + "/" + Tools.createUuid() + ".png";
            Tools.imageResize(p, Qt.size(256, 256/ratio), img, function(){
                uploadReq.file = Devices.localFilesPrePath + img;
                uploadReq.doRequest();
            });
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
                    Viewport.controller.trigger("dialog:/auth/changeName", {"text": profileLabel.text});
                    break;
                case 1:
                    Viewport.controller.trigger("dialog:/auth/changeBio", {"text": bioLabel.text});
                    break;
                case 2:
                    AsemanApp.requestPermissions(["android.permission.WRITE_EXTERNAL_STORAGE",
                                                  "android.permission.READ_EXTERNAL_STORAGE"],
                                                 function(res) {
                        if(res["android.permission.WRITE_EXTERNAL_STORAGE"] == true &&
                           res["android.permission.READ_EXTERNAL_STORAGE"] == true) {
                            Devices.getOpenPictures();
                        }
                    });
                    break;
                case 3:
                    setProfilePicReq._image = MyUserRequest._imageName;
                    setProfilePicReq.deleteRequest();
                    break;
                case 4:
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
                        title: qsTr("Change Bio"),
                        icon: "mdi_pencil",
                        enabled: true
                    },
                    {
                        title: qsTr("Change Avatar"),
                        icon: "mdi_image",
                        enabled: true
                    },
                    {
                        title: qsTr("Unset Avatar"),
                        icon: "mdi_image",
                        enabled: MyUserRequest._image.length > 0
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
