import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanObject {
    id: dis

    property alias poemId: poemReq.poem_id

    property string link
    property string title
    property int views
    property string poet
    property string phrase
    property int poetId
    property int catId
    property string poetImage
    property string poetColor

    property bool lazzyLoad: false
    readonly property int loadSteps: lazzyLoad? 200 : 100000

    property alias categoriesModel: categoriesModel
    property alias versesModel: versesModel

    readonly property bool refrshing: poemReq.refreshing || poemQuery.refreshing || randomReq.refreshing

    function random() {
        randomReq.refresh();
    }

    function clear() {
        prv.lastLoadedOffset = 0;
        prv.lastLoadedBegin = 0;
        prv.lastLoadedEnd = 0;
        poemReq.verse_limit = loadSteps;
        poemReq.verse_offset = 0;
        poemQuery.limit = loadSteps;
        poemQuery.offset = 0;
        versesModel.clear();
    }

    function more() {
        if (!lazzyLoad)
            return;

        poemQuery.more();
        poemReq.more();
    }

    function less() {
        if (!lazzyLoad)
            return;

        console.debug("less")
    }

    QtObject {
        id: prv

        property int lastLoadedOffset
        property int lastLoadedBegin
        property int lastLoadedEnd

        function analizeResult(r, offset, limit) {
            try {
                dis.title = r.poem.title;
                dis.views = r.poem.views;
                dis.phrase = r.poem.phrase;
                dis.poetId = r.poet.id;
                dis.poet = r.poet.name;
                dis.poetImage = r.poet.image;
                dis.poetColor = r.poet.color;
                dis.link = "page:/poet?id=" + r.poet.id + "&poemId=" + r.poem.id;

                if (dis.poetImage.length == 0)
                    dis.poetImage = Constants.thumbsBaseUrl +  r.poet.id + ".png"
                if (!dis.poemId)
                    dis.poemId = r.poem.id;

                categoriesModel.clear();
                categoriesModel.append({
                    title: r.poet.name,
                    id: r.poet.id,
                    link: "page:/poet?id=" + r.poet.id
                });

                r.categories.forEach(function(c){
                    c["link"] = "page:/poet?id=" + r.poet.id + "&catId=" + c.id;
                    categoriesModel.insert(1, c);
                });

                var attrs = userActions.getPoemAttributes();

                if (lastLoadedOffset === offset && lazzyLoad) {
                    for (var i=lastLoadedBegin; i<lastLoadedEnd+1 && lastLoadedBegin<versesModel.count; i++)
                        versesModel.remove(lastLoadedBegin);
                }

                var addBegin = (offset < lastLoadedOffset? true : false);

                lastLoadedBegin = (addBegin? 0 : versesModel.count);

                if (r.verses.length > 100)
                    versesModel.cachePath = "";

                var rtl = true;
                for (var vi=0; vi<r.verses.length; vi++)
                    if (r.verses[vi].position < -1) {
                        rtl = false;
                        break;
                    }

                var lastCount = versesModel.count;
                for (var vi=0; vi<r.verses.length; vi++) {
                    var v = r.verses[vi];
                    v.text = Tools.stringReplace(v.text, "\\s+", " ", true);
                    if (v.position == -1 && rtl) {
                        v.position = 4;
                    }

                    try { v.favorited = attrs[v.vorder][UserActions.TypeFavorite]; } catch (ve) { v.favorited = false; }
                    if (!v.favorited) v.favorited = false;

                    try { v.hasNote = attrs[v.vorder][UserActions.TypeNote]; } catch (ne) { v.hasNote = false; }
                    if (!v.hasNote) v.hasNote = false;

                    try { v.hasList = attrs[v.vorder][UserActions.TypeItemListsStart]; } catch (le) { v.hasList = false; }
                    if (!v.hasList) v.hasList = false;

                    if (lazzyLoad) {
                        versesModel.insert(addBegin? 0 : versesModel.count, v);
                    } else {
                        if (vi < lastCount)
                            versesModel.remove(vi);
                        versesModel.insert(vi, v);
                    }
                };

                lastLoadedEnd = (addBegin? r.verses.length - 1 : versesModel.count - 1);
                lastLoadedOffset = offset;

            } catch (e) {
            }
        }
    }

    AsemanListModel {
        id: categoriesModel
        property bool refreshing: dis.refrshing
    }
    AsemanListModel {
        id: versesModel
        property bool refreshing: dis.refrshing

        function refresh() {
            poemReq.refresh()
        }
    }

    PoemRequest {
        id: poemReq
        onResponseChanged: if (response && response.result) prv.analizeResult(response.result, verse_offset, verse_limit)

        onPoem_idChanged: {
            if (poem_id == 0)
                return;

            verse_limit = loadSteps;
            verse_offset = 0;
            Tools.jsDelayCall(10, refresh);
        }

        function more() {
            verse_offset += verse_limit;
            Tools.jsDelayCall(10, refresh);
        }
    }

    UserActions {
        id: userActions
        poetId: dis.poetId
        poemId: dis.poemId
    }

    RandomPoemRequest {
        id: randomReq
        poet_id: poetId;
        category_id: catId;
        onErrorChanged: {
            if (error.length) {
                poemQuery.random(poetId, catId, function(r){
                    if (Math.floor(randomReq.status/200) != 2) {
                        prv.analizeResult(r);
                    }
                });
            }
        }
        onResponseChanged: if (response && response.result) prv.analizeResult(response.result)
    }

    DataOfflinePoem {
        id: poemQuery
        poem_id: poemReq.poem_id

        onPoem_idChanged: {
            if (poem_id == 0)
                return;

            limit = loadSteps;
            offset = 0;
            Tools.jsDelayCall(10, refresh);
        }

        property int limit
        property int offset
        property bool refreshing: false

        function more() {
            offset += limit;
            refresh();
        }

        function refresh() {
            refreshing = true;
            getItems(function(r, offset, limit){
                refreshing = false;
                if (Math.floor(poemReq.status/200) != 2) {
                    prv.analizeResult(r, offset, limit);
                }
            }, offset, limit);
        }
    }
}
