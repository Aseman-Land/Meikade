import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import views 1.0
import models 1.0

PoetBooksView {
    width: Constants.width
    height: Constants.height

    property alias id: catsModel.poetId
    property alias catId: catsModel.parentId
    property string title
    property string url
    property alias navigData: navigModel.data

    AsemanListModel {
        id: navigModel
        data: []
    }

    headerBtn.onClicked: ViewportType.open = false

    navigationRepeater.model: navigModel

    onNavigationClicked: {
        if (index + 1 == navigModel.count)
            return;
        if (index + 2 == navigModel.count) {
            ViewportType.open = false;
            return;
        }

        properties["navigData"] = navigModel.data.slice(0, index+1);
        console.debug(Tools.variantToJson(properties))
        Viewport.controller.trigger(link, properties)
    }

    listView {
        onLinkRequest: {
            var navigData = navigModel.data;
            navigData[navigData.length] = {
                "title": properties.title,
                "link": link,
                "properties": Tools.jsonToVariant( Tools.variantToJson(properties) )
            };
            properties["navigData"] = navigData;

            Viewport.controller.trigger(link, properties)
        }
        model: CatsModel {
            id: catsModel
            cachePath: AsemanGlobals.cachePath + "/poetbook-" + poetId + "-" + parentId + ".cache"
        }
    }
}
