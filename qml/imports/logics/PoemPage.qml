import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import queries 1.0 as Query
import views 1.0
import globals 1.0
import models 1.0

PoemView {
    id: dis
    width: Constants.width
    height: Constants.height
    clip: true

    ViewportType.gestureWidth: 60 * Devices.density

    property string url
    property variant properties

    property string poetImage

    property alias id: dis.poetId
    property int poetId
    property alias poemId: poemModel.poemId
    property alias navigData: navigModel.data

    onChangeRequest: {
        url = link;
        dis.title = title;
        properties.title = title;
        properties.subtitle = subtitle;

        var poemIds = Tools.stringRegExp(link, "poemId\\=(\\d+)", false);
        var ids = Tools.stringRegExp(link, "id\\=(\\d+)", false);

        var poemId = poemIds[0][1];

        poemModel.cachePath = "";
        poemModel.clear();
        poemModel.cachePath = AsemanGlobals.cachePath + "/poem-" + poemId + ".cache";

        dis.poemId = poemIds[0][1];
        dis.id = ids[0][1];

        var navigData = Tools.toVariantList(dis.navigData)
        navigData[navigData.length-1].title = title;
        navigData[navigData.length-1].link = link;

        dis.navigData = navigData;

        properties.navigData = navigData;
        properties.neighbors = Tools.toVariantList(neighbors);
        properties.neighborsIndex = neighborsIndex;

        properties = Tools.toVariantMap(properties)

        userActionTimer.restart();
    }

    AsemanListModel {
        id: navigModel
        data: []
    }

    Query.UserActions {
        id: actionQuery
        type: Query.UserActions.TypePoemViewDate
        poemId: dis.poemId
        poetId: dis.id
        declined: 0
        synced: 0
        updatedAt: Tools.dateToSec(new Date)
        extra: {
            var map = Tools.toVariantMap(properties);
            map["title"] = title;
            map["subtitle"] = poet;
            map["image"] = poetImage;
            map["link"] = url;

            return Tools.variantToJson(map);
        }
    }

    Timer {
        id: userActionTimer
        interval: 10000
        repeat: false
        running: true
        onTriggered: {
            actionQuery.push()
            RefresherSignals.recentPoemsRefreshed()
        }
    }

    form {
        onNavigationClicked: {
            if (index + 1 == navigModel.count)
                return;

            var properties = navigModel.get(index);
            properties["navigData"] = navigModel.data.slice(0, index+1);

            Viewport.controller.trigger(link, properties);
        }

        navigationRepeater.model: navigModel

        menuBtn.onClicked: ViewportType.open = false

        gridView.model: PoemVersesModel {
            id: poemModel
            cachePath: AsemanGlobals.cachePath + "/poem-" + poemId + ".cache"
        }
    }
}
