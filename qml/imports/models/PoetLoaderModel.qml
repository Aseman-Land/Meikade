import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanObject {
    id: dis

    property alias poetId: poetReq.poet_id

    readonly property bool refrshing: poetReq.refreshing || poetQuery.refreshing

    property alias booksModel: booksModel
    property alias typesModel: typesModel
    property alias offlineInstaller: offlineInstaller

    property string username
    property string name
    property string description
    property string image
    property string wikipedia
    property string color
    property int views

    Component.onCompleted: image = Constants.thumbsBaseUrl + poetId + ".png"
    onPoetIdChanged: image = Constants.thumbsBaseUrl + poetId + ".png"

    QtObject {
        id: prv

        function analizeResult(r) {
            try {
                dis.username = r.username;
                dis.name = r.name;
                dis.description = r.description;
                dis.image = r.image;
                dis.wikipedia = r.wikipedia;
                dis.color = r.color;
                dis.views = r.views;

                if (dis.image.length == 0)
                    dis.image = Constants.thumbsBaseUrl + r.id + ".png"

                var cats = new Array;

                booksModel.clear();
                r.categories.forEach(function(c){
                    if (c.modelData)
                        booksModel.append(c);
                    else {
                        cats[cats.length] = {
                            title: c.title,
                            subtitle: "",
                            color: "",
                            image: "",
                            type: "fullback",
                            link: "page:/poet?id=" + c.poet_id + "&catId=" + c.id,
                            heightRatio: 0.6,
                            details: null
                        };
                    }
                });

                if (cats.length) {
                    booksModel.append({
                                          type: "grid",
                                          section: "",
                                          color: "transparent",
                                          background: false,
                                          modelData: cats
                                      })
                }

                typesModel.clear();
                r.types.forEach(typesModel.append);
            } catch (e) {
            }
        }
    }

    DataOfflineInstaller {
        id: offlineInstaller
        poetId: dis.poetId
        catId: 0
    }

    AsemanListModel {
        id: booksModel

        property bool refreshing: dis.refrshing

        function refresh() {
            poetReq.refresh()
        }
    }
    AsemanListModel {
        id: typesModel
    }

    PoetRequest {
        id: poetReq
        onResponseChanged: if (response && response.result) prv.analizeResult(response.result)
    }

    DataOfflinePoet {
        id: poetQuery
        poet_id: poetReq.poet_id

        onPoet_idChanged: Tools.jsDelayCall(10, refresh)

        property bool refreshing: false

        function refresh() {
            refreshing = true;
            getItems(function(r){
                refreshing = false;
                if (Math.floor(poetReq.status/200) != 2)
                    prv.analizeResult(r);
            })
        }
    }
}
