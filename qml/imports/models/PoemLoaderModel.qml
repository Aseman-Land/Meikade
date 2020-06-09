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

    property alias categoriesModel: categoriesModel
    property alias versesModel: versesModel

    readonly property bool refrshing: poemReq.refreshing || poemQuery.refreshing || randomReq.refreshing

    function random() {
        randomReq.refresh();
    }

    QtObject {
        id: prv

        function analizeResult(r) {
            try {
                dis.title = r.poem.title;
                dis.views = r.poem.views;
                dis.phrase = r.poem.phrase;
                dis.poetId = r.poet.id;
                dis.poet = r.poet.name;
                dis.poetImage = r.poet.image;
                dis.poetColor = r.poet.color;
                dis.link = "page:/poet?id=" + r.poet.id + "&poemId=" + r.poem.id

                if (dis.poetImage.length == 0)
                    dis.poetImage = Constants.thumbsBaseUrl +  r.poet.id + ".png"

                var cats = new Array;

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

                versesModel.clear();
                r.verses.forEach(function(v){
                    v.text = Tools.stringReplace(v.text, "\\s+", " ", true);
                    versesModel.append(v);
                });
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
    }

    PoemRequest {
        id: poemReq
        onResponseChanged: if (response && response.result) prv.analizeResult(response.result)

        onPoem_idChanged: Tools.jsDelayCall(10, refresh)
    }

    RandomPoemRequest {
        id: randomReq
        poet_id: poetId;
        category_id: catId;
        onResponseChanged: if (response && response.result) prv.analizeResult(response.result)
    }

    DataOfflinePoem {
        id: poemQuery
        poem_id: poemReq.poem_id

        onPoem_idChanged: Tools.jsDelayCall(10, refresh)

        property bool refreshing: false

        function refresh() {
            refreshing = true;
            getItems(function(r){
                refreshing = false;
                if (!poemReq.response)
                    prv.analizeResult(r);
            })
        }
    }
}
