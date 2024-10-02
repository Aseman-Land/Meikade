import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import Meikade 1.0
import requests 1.0
import components 1.0
import globals 1.0
import models 1.0
import "views"

PoetView {
    id: dis
    width: Constants.width
    height: Constants.height
    clip: true
    readWriteMode: true

    property string url
    property variant properties
    property alias navigData: navigModel.data

    AsemanListModel {
        id: navigModel
    }

    profileLabel.text: MyUserRequest._fullname

    poetBioScene.visible: false

    settingsLabel.visible: false
    menuBtn.onClicked: ViewportType.open = false

    progressBar.running: false
    progressBar.visible: false

    avatar.header: MyUserRequest.headers
    avatar.source: MyUserRequest._image

    gridView {
        onLinkRequest: function(link, properties) {
            var navigData = dis.navigData;
            navigData[navigData.length] = Tools.toVariantMap(properties);

            var prp = Tools.toVariantMap(properties);
            prp["navigData"] = navigData;
            prp["poet"] = dis.title;
            prp["poetImage"] = dis.image;

            Viewport.controller.trigger(link, prp);
        }

        model: BooksModel {
            bookId: 0
        }
    }
}


