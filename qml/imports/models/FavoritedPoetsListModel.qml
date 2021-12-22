import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0
import queries 1.0

AsemanListModel {
    id: dis

    property int listId: UserActions.TypeFavorite
    property bool publicList: false
    property bool flatList: false
    property int referenceId
    property string listColor: "transparent"

    Component.onCompleted: refresh()
    onPublicListChanged: save(true)
    onListColorChanged: save(publicList)
    onFlatListChanged: save(publicList)

    signal savingStarted()
    signal savingFinished()

    Connections {
        target: GlobalSignals
        onListsRefreshed: refresh()
    }

    function save(onlineSave) {
        if (obj.signalBlocker)
            return;

        savingStarted()

        var currentList = actions.query("SELECT * FROM actions WHERE type = :type AND declined = 0 AND poetId = 0 AND catId = 0 AND poemId = 0 AND verseId = 0", {"type": listId});
        var current = Tools.toVariantMap(currentList[0]);

        var extra = Tools.toVariantMap( Tools.jsonToVariant(current.extra) );
        extra["public"] = publicList;
        extra["listColor"] = listColor;
        extra["flatList"] = flatList;
        var extraJson = Tools.variantToJson(extra);

        current.extra = extraJson;

        actions.query("UPDATE actions SET extra = :extra WHERE type = :type AND declined = 0 AND poetId = 0 AND catId = 0 AND poemId = 0 AND verseId = 0", {"type": listId, "extra": extraJson});
        GlobalSignals.listsRefreshed();

        if (!onlineSave) {
            obj.deepSignalBlocker = false;
            savingFinished();
            return;
        }

        StoreActionsBulk.uploadCustomDBActions([current], function(){
            if (obj.deepSignalBlocker) {
                obj.deepSignalBlocker = false;
                savingFinished();
                return;
            }

            var req
            if (publicList) {
                req = pubReq;
                req.title = current.value;
                req.color = extra.listColor;
            } else {
                req = unpubReq;
            }
            req.poet_id = current.poetId;
            req.verse_id = current.verseId;
            req.category_id = current.catId;
            req.poem_id = current.poemId;
            req.type = current.type;
            req.doRequest();
        });
    }

    PublishListRequest {
        id: pubReq
        onSuccessfull: savingFinished()
        onErrorChanged: {
            obj.deepSignalBlocker = true;
            publicList = false;
        }
    }

    UnpublishListRequest {
        id: unpubReq
        onSuccessfull: savingFinished()
        onErrorChanged: {
            obj.deepSignalBlocker = true;
            publicList = true;
        }
    }

    UserActions {
        id: actions
    }

    QtObject {
        id: obj

        property bool signalBlocker
        property bool deepSignalBlocker
    }

    function refresh() {
        Tools.jsDelayCall(10, function(){
            if (listId == 0)
                return;

            var data = new Array;
            var current = actions.query("SELECT extra FROM actions WHERE type = :type AND declined = 0 AND poetId = 0 AND catId = 0 AND poemId = 0 AND verseId = 0", {"type": listId})

            obj.signalBlocker = true;
            publicList = false;
            listColor = "transparent"
            flatList = false;
            referenceId = 0;

            try {
                var extra = Tools.jsonToVariant(current[0].extra);
                publicList = extra["public"];
                listColor = extra["listColor"];
                flatList = extra["flatList"];
                referenceId = extra["referenceId"];
            } catch (e) {}
            obj.signalBlocker = false;

            var list = actions.query("SELECT *, COUNT(verseId) as verses FROM actions WHERE type = :type AND declined = 0 GROUP BY poetId ORDER BY updatedAt", {"type": listId});
            for (var i in list) {
                try {
                    var item = list[i];
                    if (!item.poetId && !item.catId && !item.poemId && !item.verseId)
                        continue;

                    var extraJson = Tools.jsonToVariant(item.extra);

                    if (!extraJson.poet) extraJson["poet"] = extraJson.subtitle

                    extraJson["type"] = "normal";
                    extraJson["subtitle"] = qsTr("%1 items").arg(item.verses);

                    for (var j in extraJson)
                        if (j != "extra")
                            item[j] = extraJson[j];

                    data[data.length] = item;
                } catch (e) {}
            }

            dis.data = data;
        })
    }
}
