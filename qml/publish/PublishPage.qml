import QtQuick 2.12
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import AsemanQml.Base 2.0
import models 1.0
import requests 1.0 as Req
import queries 1.0
import globals 1.0
import "views"

PublishView {
    id: dis
    width: Constants.width
    height: Constants.height

    property int poemId
    property int bookId
    property string name
    property Req.PublishPoemRequest publishReq

    finishBtn.onClicked: ViewportType.open = false
    closeBtn.onClicked: ViewportType.open = false
    agreementAcceptBtn.onClicked: {
        if (agreementAcceptBtnIndicator.running)
            return;

        agreementAcceptBtnIndicator.running = true;
        Tools.jsDelayCall(1000, function(){
            dis.progress = 0.5;
            reviewNum = 1;
            agreementAcceptBtnIndicator.running = false;
        });
    }
    reviewAcceptBtn.onClicked: {
        if (reviewAcceptBtnIndicator.running)
            return;

        reviewAcceptBtnIndicator.running = true;
        Tools.jsDelayCall(1000, function(){
            itemsList.clear();
            for (var i=0; i<reviewModel.count; i++) {
                var v = reviewModel.get(i);
                if (!v.checked)
                    continue;

                itemsList.append(v.fullData);
            }

            Req.StoreActionsBulk.uploadCustomDBActions(itemsList.toList(), function(){
                publishReq = publish_req_component.createObject(dis);
                publishReq.doNext();
            });
        })
    }

    onReloadStatesRequest: {
        var count = 0;
        for (var i=0; i<reviewModel.count; i++)
            if (reviewModel.get(i).checked)
                count++;

        reviewAcceptBtn.enabled = (count > 0);
    }

    onPoemClicked: {
        Viewport.controller.trigger("float:/mypoems/poem", {"poemId": poemId, "previewText": text, "previewType": type, "editMode": false});
    }

    Behavior on progress {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 350 }
    }
    Behavior on finishNum {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 350 }
    }
    Behavior on initedNum {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 350 }
    }
    Behavior on agreementNum {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 350 }
    }
    Behavior on reviewNum {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 350 }
    }

    ListObject {
        id: itemsList
    }

    MyPoemLoaderModel {
        id: loader
        poemId: dis.poemId
    }

    Req.TermsRequest {
        id: termsReq
        onSuccessfull: dis.agreement.text = response
    }

    UserActions {
        id: userActions
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: {
            interval = 400
            if (termsReq.refreshing)
                return;
            if (dis.initedNum == 0) {
                dis.initedNum = 1;
                if (dis.bookId)
                    loadBook("", dis.bookId)
                if (dis.poemId)
                    loadPoem(dis.poemId);
            }
            else
            if (dis.agreementNum == 0) {
                dis.progress = 0.1
                dis.agreementNum = 1;
            }
            else
                stop();
        }
    }

    function loadPoem(poemId) {
        var poems = userActions.getBooksItem(poemId);
        poems.forEach(function(p){
            var extra = Tools.jsonToVariant(p.extra);
            var m = {
                "poetId": p.poetId,
                "bookId": p.catId,
                "verseId": p.verseId,
                "poemId": p.poemId,
                "text": extra.text,
                "type": extra.type,
                "publish_status": extra["public"],
                "first_verse": extra.first_verse,
                "title": p.value,
                "section": "",
                "checked": true,
                "fullData": Tools.toVariantMap(p),
            };
            reviewModel.append(m);
        })

        reloadStatesRequest();
    }

    function loadBook(namespace, bookId) {
        userActions.catId = bookId;

        userActions.poemId = -1;
        var poems = userActions.getBooks();
        poems.forEach(function(p){
            var extra = Tools.jsonToVariant(p.extra);
            var m = {
                "poetId": p.poetId,
                "bookId": p.catId,
                "verseId": p.verseId,
                "poemId": p.poemId,
                "text": extra.text,
                "type": extra.type,
                "publish_status": extra["public"],
                "first_verse": extra.first_verse,
                "title": p.value,
                "section": namespace,
                "checked": true,
                "fullData": Tools.toVariantMap(p),
            };
            reviewModel.append(m);
        })

        userActions.poemId = 0;
        var books = userActions.getBooks();
        books.forEach(function(b){
            loadBook((namespace.length? ", " : "") + b.value, b.type)
        });

        reloadStatesRequest();
    }

    Component {
        id: publish_req_component
        Req.PublishPoemRequest {
            id: publishReq

            onErrorChanged: {
                reviewAcceptBtnIndicator.running = false;
                publishReq.destroy();
            }

            onSuccessfull: doNext()

            function doNext() {
                if (itemsList.isEmpty()) {
                    dis.progress = 1
                    finishNum = 1
                    reviewAcceptBtnIndicator.running = false;
                    publishReq.destroy();
                    return;
                }

                var m = itemsList.takeFirst();
                publishReq.poet_id = m.poetId;
                publishReq.verse_id = m.verseId;
                publishReq.category_id = m.catId;
                publishReq.poem_id = m.poemId;
                publishReq.type = m.type;
                publishReq.doRequest();
            }
        }
    }
}



