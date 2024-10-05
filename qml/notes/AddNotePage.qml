import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import requests 1.0
import queries 1.0
import globals 1.0
import "views"
import "../lists/views"

AddNoteView {
    id: home

    property alias poetId: createAction.poetId
    property alias poemId: createAction.poemId
    property alias catId: createAction.catId
    property alias verseId: createAction.verseId
    property string extra

    signal saved(string text)
    signal poemRequest()

    closeBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: confirm()

    noteField.onCursorRectangleChanged: ensureVisible(noteField.cursorRectangle)

    deleteBtn.visible: createAction.value.length > 0
    deleteBtn.onClicked: Viewport.viewport.append(delete_component, {}, "bottomdrawer")

    poemBtn.onClicked: {
//        ViewportType.open = false;
        poemRequest();
    }

    Component.onCompleted: {
        if (poemText.length == 0)
            loader.poemId = home.poemId
    }

    premiumMsg: {
        if (Subscription.premium || Subscription.notesLimits < 0 || !Bootstrap.initialized)
            return "";

        var tgLink = "<a href='https://t.me/poshtibanimoon'>" + qsTr("Click Here") +"</a>";
        if (Bootstrap.payment && Bootstrap.trusted)
            return GTranslations.translate( qsTr("You create %1 note from %2 notes, Allowed to create using non-premium account.").arg(currentNotesCount).arg(Subscription.notesLimits) )
        else
            return GTranslations.translate( qsTr("You create %1 note from %2 notes. for more information contact us on telegram:").arg(currentNotesCount).arg(Subscription.notesLimits) ) + " " + tgLink
    }

    onPremiumBuyRequest: Viewport.controller.trigger("blurbottomdrawer:/account/premium/buy")

    function ensureVisible(r)
    {
        var zeroY = noteField.mapToItem(scene, 0, 0).y;
        var rY = zeroY + r.y;
        if (home.flick.contentY >= rY - zeroY)
            home.flick.contentY = rY - zeroY;
        else if (home.flick.contentY + home.flick.height <= rY + r.height + keyboardHeight)
            home.flick.contentY = rY + r.height + keyboardHeight - home.flick.height;
    }

    function confirm() {
        var extra = Tools.jsonToVariant(home.extra);
        extra["public"] = false;

        var text = noteField.text.trim();

        createAction.value = text;
        createAction.declined = (text.length? 0 : 1)
        createAction.extra = Tools.variantToJson(extra, true);
        createAction.pushAction();

        GlobalSignals.notesRefreshed()
        home.ViewportType.open = false;

        home.saved(text);
    }

    PoemLoaderModel {
        id: loader
        onFinished: {
            var index = 0;
            for (var i=0; i<versesModel.count; i++) {
                var m = versesModel.get(i);
                if (m.vorder == verseId) {
                    index = i;
                    break;
                }
            }

            var poemText = getText(false, index);
            home.poemText = Tools.stringReplace(poemText, "\n+", "\n", true);
        }
    }

    UserActions {
        id: createAction
        type: UserActions.TypeNote
        poemId: 0
        poetId: 0
        declined: 0
        Component.onCompleted: {
            fetch()
            home.noteField.text = value;

            queryAsync("SELECT COUNT(*) as cnt FROM actions WHERE type = :type AND declined = 0", {"type": UserActions.TypeNote}, function(res){
                currentNotesCount = res[0].cnt;
            })
        }
    }

    Component {
        id: delete_component
        DeleteListView {
            id: deleteDialog
            width: parent.width
            height: 240 * Devices.density
            bodyLabel.text: qsTr("Are you sure about delete this note?") + Translations.refresher
            rejectBtn.onClicked: deleteDialog.ViewportType.open = false;
            confirmBtn.onClicked: {
                deleteDialog.ViewportType.open = false;
                noteField.text = "";
                home.confirm();
            }
        }
    }
}


