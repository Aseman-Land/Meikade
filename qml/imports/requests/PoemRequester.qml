pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0
import routes 1.0

AsemanObject {
    id: dis

    MapObject {
        id: map
    }

    function init() {}

    function load(poemId, page) {
        var allowGlobalBusy = (page == undefined? true : false)

        var req = poemReq_component.createObject(dis, {"allowGlobalBusy": allowGlobalBusy});
        req.poem_id = poemId;
        req.responseChanged.connect(function(){
            try {
                var r = req.response.result;
                var catId = r.poem.category_id;

                var catReq = catReq_component.createObject(dis, {"allowGlobalBusy": allowGlobalBusy});
                catReq.poet_id = r.poet.id;
                catReq.parent_id = catId;

                catReq.responseChanged.connect(function(){
                    var neighbors = new Array;
                    try {
                        var nb = catReq.response.result[0].modelData;
                        for (var j in nb) {
                            var c = nb[j];
                            neighbors[neighbors.length] = {
                                "link": c.link,
                                "title": c.title,
                                "subtitle": c.subtitle
                            };
                        }

                        var unit = convertUnitToMap(r);
                        unit["neighbors"] = neighbors;

                        if (page == undefined)
                            ViewController.trigger(unit.link, unit);
                        else {
                            for (var i in unit) {
                                try {
                                    page[i] = unit[i];
                                } catch (e3) {}
                            }
                        }

                        req.destroy();
                        catReq.destroy();
                    } catch (e2) {}

                });

                catReq.networkManager.get(catReq);
            } catch (e) {}
        });

        req.networkManager.get(req);
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
        id: poemReq_component
        PoemRequest {}
    }
    Component {
        id: catReq_component
        CatsRequest {}
    }
}
