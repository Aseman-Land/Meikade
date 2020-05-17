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

    property string url
    property variant properties

    property int poetId
    property string poetImage

    property alias poemId: poemModel.poemId
    property alias navigData: navigModel.data

    AsemanListModel {
        id: navigModel
        data: []
    }

    Query.UserActions {
        id: actionQuery
        type: Query.UserActions.TypePoemViewDate
        poemId: dis.poemId
        poetId: dis.poetId
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

    Behavior on coverScene.y {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
    }
    Behavior on statusBarRect.opacity {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
    }

    onNavigationClicked: {
        if (index + 1 == navigModel.count)
            return;

        properties["navigData"] = navigModel.data.slice(0, index+1);
        Viewport.controller.trigger(link, properties)
    }

    navigationRepeater.model: navigModel

    menuBtn.onClicked: ViewportType.open = false

    gridView.model: PoemVersesModel {
        id: poemModel
        cachePath: AsemanGlobals.cachePath + "/poem-" + poemId + ".cache"
    }
}
