import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0
import models 1.0

PoetView {
    id: dis
    width: Constants.width
    height: Constants.height
    clip: true

    property string url
    property variant properties
    property alias id: catsModel.poetId
    property alias navigData: navigModel.data

    AsemanListModel {
        id: navigModel
        data: [properties]
    }

    bioBtn.onClicked: Viewport.controller.trigger("popup:/poet/bio")
    menuBtn.onClicked: ViewportType.open = false

    gridView {
        onLinkRequest: {
            var navigData = navigModel.data;
            navigData[navigData.length] = Tools.toVariantMap(properties);

            var prp = Tools.toVariantMap(properties);
            prp["navigData"] = navigData;
            prp["poet"] = dis.title;
            prp["poetImage"] = dis.image;

            Viewport.controller.trigger(link, prp);
        }
        model: CatsModel {
            id: catsModel
            cachePath: AsemanGlobals.cachePath + "/poet-" + poetId + ".cache"
        }
    }
}
