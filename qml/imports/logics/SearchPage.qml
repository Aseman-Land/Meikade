import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import models 1.0
import views 1.0
import requests 1.0
import globals 1.0

SearchView {
    id: home

    property int poetId
    readonly property real tabletWidth: Viewport.viewport.width > Viewport.viewport.height && !Devices.isMobile? Viewport.viewport.height * 3 / 5 : 0

    keywordField.onTextChanged: {
        if (Bootstrap.paymentUnlockCode.length && keywordField.text == Bootstrap.paymentUnlockCode) {
            Bootstrap.initialized = true;
            Bootstrap.payment = true;
            Bootstrap.subscription = true;
            Bootstrap.trusted = true;
            GlobalSignals.snackbarRequest(":)");
        }
        else
        if (unlockPassword.length && keywordField.text == unlockPassword) {
            Bootstrap.fullyUnlocked = true;
            Bootstrap.initialized = true;
            Bootstrap.payment = true;
            Bootstrap.subscription = true;
            Bootstrap.trusted = true;
            GlobalSignals.snackbarRequest(":)");
        }
    }

    onPoetIdChanged: loadPoetId()

    resultHeaderLabel.text: {
        if (listView.count == 0 && !poetsList.visible && !listsList.visible)
            return "";
        if (listView.model === searchModel || (listView.count == 0))
            return qsTr("Online Results") + Translations.refresher;
        else
            return qsTr("Offline Results") + Translations.refresher;
    }

    domainText.text: {
        var res = searchFilterModel.count? "" : qsTr("All Poets");
        for (var i=0; i<searchFilterModel.count; i++) {
            if (i !== 0)
                res += ", ";
            res += searchFilterModel.get(i).title;
        }
        return res;
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

    listsList {
        model: SearchListModel {
            id: listsSearchModel
            query: Bootstrap.initialized? home.keywordField.text : ""
        }
        visible: {
            for (var i=0; i<listsSearchModel.count; i++)
                if (listsSearchModel.get(i).modelData.length > 0)
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

        var neighbors = new Array;
        for (var i=0; i<listView.model.count; i++) {
            var n = listView.model.get(i);
            try {
                neighbors[neighbors.length] = {
                    "link": n.link,
                    "subtitle": "0 poems",
                    "title": n.poem.title,
                    "verseId": n.verses[0].vorder,
                    "poet": n.poet.name
                };
            } catch(e) {}
        }

        properties["neighbors"] = neighbors;
        properties["neighborsIndex"] = index;

        Viewport.controller.trigger(link, properties);
    }

    onMoreRequest: listView.model.more();

    busyIndicator.running: ((listsSearchModel.refreshing || searchModel.refreshing || poetsSearchModel.refreshing) && AsemanGlobals.onlineSearch) || ((searchModel.count == 0 || !AsemanGlobals.onlineSearch) && searchOfflineModel.refreshing)

    listView {
        model: (searchModel.count || searchModel.refreshing) && AsemanGlobals.onlineSearch? searchModel : searchOfflineModel
        onCountChanged: {
            if (!listView.initializeState)
                return;

            listInitTimer.restart();
            listView.initializeState = false;
        }
    }

    Timer {
        id: listInitTimer
        repeat: false
        interval: 1
        onTriggered: listView.positionViewAtBeginning()
    }

    Connections {
        target: Viewport.viewport
        onCountChanged: home.keywordField.focus = false;
    }

    AsemanListModel {
        id: searchFilterModel
        cachePath: AsemanGlobals.cachePath + "/searchfilters.cache"
    }

    SearchVerseModel {
        id: searchModel
        query: home.keywordField.text
        smart: AsemanGlobals.smartSearch
        poets: {
            var res = new Array;
            for (var i=0; i<searchFilterModel.count; i++)
                res[res.length] = searchFilterModel.get(i).id;
            return res;
        }
    }
    SearchVerseOfflineModel {
        id: searchOfflineModel
        query: home.keywordField.text
        poets: {
            var res = new Array;
            for (var i=0; i<searchFilterModel.count; i++)
                res[res.length] = searchFilterModel.get(i).id;
            return res;
        }
    }

    MapObject {
        id: map
    }

    function loadPoetId() {
        if (poetId == 0)
            return;

        searchFilterModel.cachePath = "";
        searchFilterModel.clear();
        for (var i=0; i<poetsModel.count; i++)
            if (poetsModel.get(i).id == poetId) {
                searchFilterModel.append( poetsModel.get(i) );
                break;
            }
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

    PoetsCleanModel {
        id: poetsModel
        cachePath: AsemanGlobals.cachePath + "/searchpoets.cache"
        onCountChanged: loadPoetId()
    }

    Component {
        id: filter_component
        SearchFilterPage {
            width: tabletWidth? tabletWidth : home.width
            height: View.root.height * 0.9
            x: Viewport.viewport.width/2 - width/2
            poetsList.model: onlineSearchSwitch.checked? poetsModel : offlinePoetsModel
            acceptBtn.onClicked: {
                searchFilterModel.clear();
                for (var i=0; i<selectedListModel.count; i++)
                    searchFilterModel.append( selectedListModel.get(i) );

                AsemanGlobals.onlineSearch = onlineSearchSwitch.checked;
                if (AsemanGlobals.onlineSearch)
                    AsemanGlobals.smartSearch = !accurateSearchSwitch.checked;
                ViewportType.open = false;
            }
            cancelBtn.onClicked: ViewportType.open = false;
            Component.onCompleted: {
                for (var i=0; i<searchFilterModel.count; i++)
                    selectedListModel.append( searchFilterModel.get(i) );
            }

            OfflinePoetsModel {
                id: offlinePoetsModel
                cleanData: true
            }
        }
    }
}
