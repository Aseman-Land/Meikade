pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.MaterialIcons 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    id: model

    property alias refreshing: req.refreshing
    property alias hash: hash

    HashObject {
        id: hash

        function createKey(poet, cat, poem, verse, type) {
            return Tools.md5(poet + "-" + cat + "-" + poem + "-" + verse+ "-" + type);
        }
        function add(poet, cat, poem, verse, type) {
            insert(createKey(poet, cat, poem, verse, type), true);
        }
        function del(poet, cat, poem, verse, type) {
            remove(createKey(poet, cat, poem, verse, type));
        }
        function test(poet, cat, poem, verse, type) {
            return contains(createKey(poet, cat, poem, verse, type));
        }
        function addCat(c) {
            add(c.type, 0, 0, 0, 0);
            c.poems.forEach(function(p){
                add(0, p.category_id, p.type, 0, 0);
                c.categories.forEach(addCat);
            });
        }
    }

    GetUserRequestsRequest {
        id: req
        onSuccessfull: {
            model.clear();
            hash.clear();
            response.result.forEach(function(o){
                var m = Tools.jsonToVariant("{}");
                m.created_at = Tools.dateFromSec( Math.floor(Date.parse(o.created_at) / 1000) );
                m.expires_at = Tools.dateFromSec( Math.floor(Date.parse(o.expires_at) / 1000) );
                m.title = o.content.value.trim();
                m.categories = "";
                o.content.categories.forEach(function(c){
                    m.categories += c.value + " ";
                });
                m.description = o.description;
                m.status = o.status_id;
                switch (m.status) {
                case 0: // Reviewing
                    m.icon = "mdi_magnify";
                    m.color = Colors.accent;
                    break;
                case 1: // Accepting
                    m.icon = "mdi_checkbox_multiple_marked_circle";
                    m.color = Colors.accent;

                    hash.add(o.action.poet_id, o.action.category_id, o.action.poem_id, o.action.verse_id, o.action.type);
                    hash.add(o.action.type, 0, 0, 0, 0);
                    o.content.categories.forEach(hash.addCat);
                    break;
                case 2: // Rejected
                    m.icon = "mdi_alert_octagon";
                    m.color = "#d80000";
                    break;
                }

                m.categories = m.categories.trim();
                m.body = o.status.trim();
                model.insert(0, m);
            });
        }
    }

    function init() {
        req.doRequest();
    }

    function refresh() {
        req.doRequest();
    }

    Component.onCompleted: init()
}
