import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import queries 1.0
import globals 1.0

AsemanListModel {
    id: lmodel

    readonly property bool refreshing: searchQuery.refreshing || timer.running
    property alias query: searchQuery.query
    property alias poets: searchQuery.poets

    onQueryChanged: {
        searchQuery.offset = 0;
        timer.restart()
    }
    onPoetsChanged: timer.restart()

    function more() {
        searchQuery.offset = count
        searchQuery.refresh()
    }

    Timer {
        id: timer
        interval: 1000
        repeat: false
        onTriggered: searchQuery.refresh();
    }

    MapObject { id: verseMap }
    MapObject { id: catMap }

    SearchVerseQuery {
        id: searchQuery

        property bool refreshing

        function refresh() {
            refreshing = true;

            if (offset == 0)
                lmodel.clear();

            searchQuery.getItems(function(list, err){
                refreshing = false;

                var res = new Array;
                list.forEach( function(l){
                    var poem = {
                        id: l.poem__id,
                        category_id: l.poem__category_id,
                        title: l.poem__title,
                        views: l.poem__views
                    };

                    var poet = {
                        id: l.poet__id,
                        name: l.poet__name,
                        username: l.poet__username,
                        views: l.poem__views
                    };

                    var cat1 = {
                        id: l.categories__id,
                        title: l.categories__title
                    };

                    var cat2 = {
                        id: l.categories2__id,
                        title: l.categories2__title
                    };

                    catMap.clear();
                    if (cat1.title.length) catMap.insert(cat1.id, cat1);
                    if (cat2.title.length) catMap.insert(cat2.id, cat2);


                    var verses1 = {
                        vorder: l.verses__vorder,
                        text: l.verses__text,
                        position: l.verses__position
                    };

                    var verses2 = {
                        vorder: l.verses2__vorder,
                        text: l.verses2__text,
                        position: l.verses2__position
                    };

                    verseMap.clear();
                    if (verses1.text.length) verseMap.insert(verses1.vorder, verses1);
                    if (verses2.text.length) verseMap.insert(verses2.vorder, verses2);

                    res[res.length] = {
                        poem: poem,
                        poet: poet,
                        link: "page:/poet?id=" + poet.id + "&poemId=" + poem.id,
                        categories: catMap.values,
                        verses: verseMap.values
                    };
                });

                res.forEach(lmodel.append);
            });
        }
    }
}

