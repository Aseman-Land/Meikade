import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import globals 1.0

SearchView {
    id: home

    onClicked: {
        var item = searchModel.get(index);
        var properties = PoemRequester.convertUnitToMap(item);
        properties["verseId"] = item.verses[0].vorder;

        Viewport.controller.trigger(link, properties);
    }

    listView {
        model: SearchVerseModel {
            id: searchModel
            query: home.keywordField.text
        }
    }
}
