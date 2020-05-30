import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import globals 1.0

SearchView {
    id: home

    onClicked: {
        var item = searchModel.get(index);

        var navigData = new Array;
        navigData[navigData.length] = {
            title: item.poet.name,
            link: "page:/poet?id=" + item.poet.id
        }

        for (var i in item.categories) {
            var cat = item.categories[i];
            navigData[navigData.length] = {
                title: cat.title,
                link: "page:/poet?id=" + item.poet.id + "&catId=" + cat.id
            }
        }

        navigData[navigData.length] = {
            title: item.poem.title,
            link: link
        }

        var properties = {
            title: item.poem.title,
            poet: item.poet.name,
            poetImage: Constants.thumbsBaseUrl + item.poet.id + ".png",
            navigData: navigData,
            color: "",
            type: "normal",
            verseId: item.verses[0].vorder
        };

        Viewport.controller.trigger(link, properties);
    }

    listView {
        model: SearchVerseModel {
            id: searchModel
            query: home.keywordField.text
        }
    }
}
