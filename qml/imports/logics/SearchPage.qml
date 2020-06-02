import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import globals 1.0

SearchView {
    id: home

    resultHeaderLabel.text: {
        if (listView.count == 0)
            return "";
        if (listView.model === searchModel)
            return qsTr("Online Results") + Translations.refresher;
        else
            return qsTr("Offline Results") + Translations.refresher;
    }

    poetsBusyIndicator.running: poetsModel.refreshing
    poetCombo.textRole: "title"
    poetCombo.currentIndex: 0
    poetCombo.model: PoetsCleanModel {
        id: poetsModel
        cachePath: AsemanGlobals.cachePath + "/search-poets.cache"
        onCountChanged: if (count && get(0).id != 0) insert(0, {"title": qsTr("All Poets"), "id": 0})
    }

    onClicked: {
        var item = searchModel.get(index);
        var properties = PoemRequester.convertUnitToMap(item);
        properties["verseId"] = item.verses[0].vorder;

        Viewport.controller.trigger(link, properties);
    }

    onMoreRequest: listView.model.more();

    busyIndicator.running: searchModel.refreshing

    listView {
        model: searchModel.count || searchModel.refreshing? searchModel : searchOfflineModel
    }

    Connections {
        target: Viewport.viewport
        onCountChanged: home.keywordField.focus = false;
    }

    SearchVerseModel {
        id: searchModel
        query: home.keywordField.text
        poetId: poetCombo.currentIndex > 0 && poetCombo.currentIndex < poetsModel.count? poetsModel.get(poetCombo.currentIndex).id : 0
    }
    SearchVerseOfflineModel {
        id: searchOfflineModel
        query: home.keywordField.text
        poetId: poetCombo.currentIndex > 0 && poetCombo.currentIndex < poetsModel.count? poetsModel.get(poetCombo.currentIndex).id : 0
    }
}
