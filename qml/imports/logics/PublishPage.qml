import QtQuick 2.12
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import AsemanQml.Base 2.0
import models 1.0
import requests 1.0 as Req
import views 1.0
import queries 1.0
import globals 1.0

PublishView {
    id: dis
    width: Constants.width
    height: Constants.height

    property int poemId
    property int bookId
    property string name
    property variant items: new Array

    finishBtn.onClicked: ViewportType.open = false
    closeBtn.onClicked: ViewportType.open = false
    agreementAcceptBtn.onClicked: {
        if (agreementAcceptBtnIndicator.running)
            return;

        agreementAcceptBtnIndicator.running = true;
        Tools.jsDelayCall(1000, function(){
            dis.progress = 0.5
            reviewNum = 1
            agreementAcceptBtnIndicator.running = false;
        })
    }
    reviewAcceptBtn.onClicked: {
        if (reviewAcceptBtnIndicator.running)
            return;

        reviewAcceptBtnIndicator.running = true;
        Tools.jsDelayCall(1000, function(){
            Req.StoreActionsBulk.uploadCustomDBActions(items, function(){
                dis.progress = 1
                finishNum = 1
                reviewAcceptBtnIndicator.running = false;
            })
        })
    }

    onPoemClicked: {
        Viewport.controller.trigger("popup:/mypoems/poem", {"poemId": poemId, "previewText": text, "previewType": type, "editMode": false});
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
        interval: 3000
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
                "bookId": p.catId,
                "poemId": p.type,
                "text": extra.text,
                "type": extra.type,
                "publish_status": extra["public"],
                "first_verse": extra.first_verse,
                "title": p.value,
                "section": "",
                "checked": true,
            };
            reviewModel.append(m);
            items[items.length] = p;
        })
    }

    function loadBook(namespace, bookId) {
        userActions.catId = bookId;

        userActions.poemId = -1;
        var poems = userActions.getBooks();
        poems.forEach(function(p){
            var extra = Tools.jsonToVariant(p.extra);
            var m = {
                "bookId": p.catId,
                "poemId": p.type,
                "text": extra.text,
                "type": extra.type,
                "publish_status": extra["public"],
                "first_verse": extra.first_verse,
                "title": p.value,
                "section": namespace,
                "checked": true,
            };
            reviewModel.append(m);
            items[items.length] = p;
        })

        userActions.poemId = 0;
        var books = userActions.getBooks();
        books.forEach(function(b){
            loadBook((namespace.length? ", " : "") + b.value, b.type)
        });
    }
}

