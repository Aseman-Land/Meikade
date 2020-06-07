pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import routes 1.0

AsemanObject {
    id: dis

    function random(poetId, catId) {
        prv.tries = 6;
        ViewController.waitCount++;
        prv.random(poetId, catId);
    }

    QtObject {
        id: prv

        property int tries

        function showConnectionError() {
            ViewController.trigger("dialog:/general/error", {"title": qsTr("Failed"), "body": qsTr("Please check internet connection.")})
        }

        function random(poetId, catId, poemId) {
            tries--;
            if (tries < 0) {
                ViewController.waitCount--;
                ViewController.trigger("dialog:/general/error", {"title": qsTr("Failed"), "body": qsTr("Too many tries. Please try again")})
                return;
            }

            var req
            if (poetId == undefined || poetId == 0) {
                req = poetsReq_component.createObject(dis);
                req.responseChanged.connect( function(){
                    if (!req.response)
                        return;

                    try {
                        var res = req.response.result;
                        var rnd = Math.floor(Math.random() * (res.length+1));
                        if (rnd >= res.length)
                            rnd = res.length - 1;

                        random(res[rnd].id);
                    } catch (e) {
                        ViewController.waitCount--;
                        showConnectionError();
                    }

                    req.destroy();
                })
            } else
            if (poemId == undefined || poemId == 0) {
                var cid = (catId == undefined? 0 : catId)

                req = catReq_component.createObject(dis, {"poet_id": poetId, "parent_id": cid});
                req.responseChanged.connect( function(){
                    if (!req.response)
                        return;

                    try {
                        var res = req.response.result[0].modelData;
                        var rnd = Math.floor(Math.random() * (res.length+1));
                        if (rnd >= res.length)
                            rnd = res.length - 1;

                        var link = res[rnd].link;
                        var caps = Tools.stringRegExp(link, "^\\w+\\:\\/poet\\?id\\=(\\d+)\\&catId\\=([\\-\\d]\\d*)$");
                        if (caps.length !== 0) {
                            var catId = caps[0][2] * 1;
                            if (catId < 0)
                                catId = 0;

                            random(poetId, catId);
                        } else {
                            caps = Tools.stringRegExp(link, "^\\w+\\:\\/poet\\?id\\=(\\d+)\\&poemId\\=([\\-\\d]\\d*)$");
                            var poemId = caps[0][2] * 1;

                            random(poetId, catId, poemId);
                        }
                    } catch (e) {
                        ViewController.waitCount--;
                        showConnectionError();
                    }

                    req.destroy();
                })
            } else {
                req = poemReq_component.createObject(dis, {"poem_id": poemId});
                req.responseChanged.connect( function(){
                    if (!req.response)
                        return;

                    try {
                        var res = req.response.result;
                        var properties = {
                            title: res.poem.title,
                            poet: res.poet.name
                        };

                        ViewController.waitCount--;
                        ViewController.trigger("page:/poet?id=" + poetId + "&poemId=" + poemId, properties);
                    } catch (e) {
                        ViewController.waitCount--;
                        showConnectionError();
                    }

                    req.destroy();
                });
                req.refresh()
            }
        }
    }

    Component {
        id: poemReq_component
        PoemRequest {}
    }
    Component {
        id: catReq_component
        CatsRequest {}
    }
    Component {
        id: poetsReq_component
        SimplePoetsRequest {}
    }
}
