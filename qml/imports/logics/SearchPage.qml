import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import views 1.0
import requests 1.0
import globals 1.0

SearchView {
    id: home

    property int poetId

    resultHeaderLabel.text: {
        if (listView.count == 0 && !poetsList.visible)
            return "";
        if (listView.model === searchModel)
            return qsTr("Online Results") + Translations.refresher;
        else
            return qsTr("Offline Results") + Translations.refresher;
    }

    poetsBusyIndicator.running: poetsModel.refreshing
    poetCombo.visible: false
    poetCombo.textRole: "title"
    poetCombo.currentIndex: 0
    poetCombo.model: PoetsCleanModel {
        id: poetsModel
        cachePath: AsemanGlobals.cachePath + "/search-poets.cache"
        onCountChanged: {
            if (count && get(0).id != 0)
                insert(0, {"title": qsTr("All Poets"), "id": 0})
            if (poetId) {
                for (var i=0; i<count; i++)
                    if (get(i).id == poetId)
                        poetCombo.currentIndex = i;
            }
        }
    }

    poetsList {
        model: SearchPoetsModel {
            id: poetsSearchModel
            query: home.keywordField.text
        }
        visible: {
            for (var i=0; i<poetsSearchModel.count; i++)
                if (poetsSearchModel.get(i).modelData.length > 0)
                    return true;
            return false;
        }

        onLinkRequest: {
            var prp = Tools.toVariantMap(properties);
            Viewport.controller.trigger(link, prp);
        }
    }

    poetsFilterArea.onClicked: Viewport.viewport.append(filter_component, {}, "bottomdrawer")

    onClicked: {
        var item = listView.model.get(index);
        var properties = convertUnitToMap(item);
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
        poets: {
            var res = new Array;
            if (poetCombo.currentIndex > 0 && poetCombo.currentIndex < poetsModel.count)
                res[res.length] = poetsModel.get(poetCombo.currentIndex).id;
            return res;
        }
    }
    SearchVerseOfflineModel {
        id: searchOfflineModel
        query: home.keywordField.text
        poetId: poetCombo.currentIndex > 0 && poetCombo.currentIndex < poetsModel.count? poetsModel.get(poetCombo.currentIndex).id : 0
    }

    MapObject {
        id: map
    }

    function convertUnitToMap(r) {
        var navigData = new Array;
        navigData[navigData.length] = {
            title: r.poet.name,
            link: "page:/poet?id=" + r.poet.id
        }

        map.clear();
        for (var i in r.categories) {
            var cat = r.categories[i];
            map.insert(cat.id, {
                           title: cat.title,
                           link: "page:/poet?id=" + r.poet.id + "&catId=" + cat.id
                       });
        }

        for (var i in map.values) {
            navigData[navigData.length] = map.values[i];
        }

        navigData[navigData.length] = {
            title: r.poem.title,
            link: "page:/poet?id=" + r.poet.id + "&poemId=" + r.poem.id
        };

        var properties = {
            title: r.poem.title,
            poet: r.poet.name,
            poetImage: Constants.thumbsBaseUrl + r.poet.id + ".png",
            navigData: navigData,
            color: "",
            link: "page:/poet?id=" + r.poet.id + "&poemId=" + r.poem.id,
            type: "normal"
        };

        return properties;
    }

    Component {
        id: filter_component
        SearchFilterPage {
            width: parent.width
            height: View.root.height * 0.9
            poetsList.model: poetCombo.model
        }
    }
}
