import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0
import queries 1.0

AsemanListModel {

    UserActions {
        id: actions
    }

    HashObject {
        id: jsonsHash
    }

    ModelFormatHint {
        path: "type"
        method: function(arg) { return "normal"; }
    }


    ModelCopyHint {
        path: "extra"
        targetPath: "title"
    }
    ModelCopyHint {
        path: "extra"
        targetPath: "subtitle"
    }
    ModelCopyHint {
        path: "extra"
        targetPath: "link"
    }
    ModelCopyHint {
        path: "extra"
        targetPath: "color"
    }
    ModelCopyHint {
        path: "extra"
        targetPath: "image"
    }

    ModelFormatHint {
        path: "title"
        method: function(arg) { return getJsonObj(arg).title; }
    }
    ModelFormatHint {
        path: "subtitle"
        method: function(arg) { return getJsonObj(arg).subtitle; }
    }
    ModelFormatHint {
        path: "link"
        method: function(arg) { return getJsonObj(arg).link; }
    }
    ModelFormatHint {
        path: "color"
        method: function(arg) { return getJsonObj(arg).color; }
    }
    ModelFormatHint {
        path: "image"
        method: function(arg) { return getJsonObj(arg).image; }
    }
    ModelFormatHint {
        path: "type"
        method: function() { return "normal"; }
    }

    function refresh() {
        data = actions.getItems(UserActions.TypePoetViewDate, 0, 10)
    }

    function getJsonObj(json) {
        var res = jsonsHash.value(json);
        if (res)
            return res;

        res = Tools.jsonToVariant(json)
        jsonsHash.insert(json, res);
        return res;
    }

    Component.onCompleted: refresh()
}
