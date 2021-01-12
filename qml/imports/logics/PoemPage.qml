import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import queries 1.0 as Query
import views 1.0
import globals 1.0
import models 1.0
import micros 1.0

PoemView {
    id: dis
    width: Constants.width
    height: Constants.height
    clip: true

    ViewportType.gestureWidth: menuObject? 0 : 150 * Devices.density

    property string url

    property string verseText
    property int verseId

    property alias id: loader.poetId
    property alias poetId: loader.poetId
    property alias catId: loader.catId

    property alias poemId: loader.poemId
    property alias title: loader.title
    property alias poet: loader.poet
    property alias subtitle: loader.poet
    property alias image: loader.poetImage

    onPoemIdChanged: form.selectMode = false;
    onVerseIdChanged: highlightTimer.restart()

    onChangeRequest: {
        url = link;
        dis.title = title;

        var poemIds = Tools.stringRegExp(link, "poemId\\=(\\d+)", false);
        var ids = Tools.stringRegExp(link, "id\\=(\\d+)", false);

        var poemId = poemIds[0][1];

        loader.clear()
        loader.poemId = poemId;

        dis.poemId = poemIds[0][1];
        dis.id = ids[0][1];

        userActionTimer.restart();
    }

    function getText(cleanText) {
        var text = "";
        for (var i=0; i<loader.versesModel.count; i++) {
            var e = loader.versesModel.get(i);
            if (form.selectMode && form.selectedList.length) {
                if ((e.position !== PoemVersesModel.PositionSingle || !form.selectedList[i]) &&
                    ((e.position !== PoemVersesModel.PositionLeft && e.position !== PoemVersesModel.PositionCenteredVerse2) || !form.selectedList[i-1]) &&
                    ((e.position !== PoemVersesModel.PositionRight && e.position !== PoemVersesModel.PositionCenteredVerse1) || !form.selectedList[i]))
                    continue;
            }

            text += e.text + "\n";
            if (e.position === PoemVersesModel.PositionLeft || e.position === PoemVersesModel.PositionCenteredVerse2)
                text += "\n";
        }

        if (!cleanText) {
            for (var j=0; j<loader.categoriesModel.count; j++) {
                text += loader.categoriesModel.get(j).title
                if (j < loader.categoriesModel.count-1)
                    text += ", ";
                else
                    text += "\n";
            }

            text += poet;
        } else {
            text = Tools.stringReplace(text, "\n+", "\n", true);
        }

        return text.trim();
    }

    Component.onCompleted: if (loader.poemId == 0) loader.random()
    Component.onDestruction: if (menuObject) menuObject.ViewportType.open = false

    PoemLoaderModel {
        id: loader
        poemId: dis.poemId
        versesModel.cachePath: poemId? AsemanGlobals.cachePath + "/poem-" + poemId + ".cache" : ""
    }

    Timer {
        id: highlightTimer
        interval: 500
        repeat: false
        onTriggered: {
            if (loader.versesModel.count == 0) {
                restart(); // More delay to load model
                return;
            }

            for (var i=0; i<loader.versesModel.count; i++)
                if (verseId == loader.versesModel.get(i).vorder) {
                    dis.form.highlightItemIndex = i;
                    dis.form.highlighItemRatio = 1;

                    highlighAnimation.from = dis.form.listView.contentY;
                    dis.form.listView.positionViewAtIndex(i, ListView.Center);
                    highlighAnimation.to = dis.form.listView.contentY;
                    highlighAnimation.restart();

                    highlightBackTimer.restart();
                    break;
                }
        }
    }

    Timer {
        id: highlightBackTimer
        interval: 2000
        repeat: false
        onTriggered: dis.form.highlighItemRatio = 0
    }

    NumberAnimation {
        id: highlighAnimation
        duration: 300
        target: dis.form.listView
        property: "contentY"
    }

    Query.UserActions {
        id: viewActionQuery
        type: Query.UserActions.TypePoemViewDate
        poemId: dis.poemId
        poetId: dis.id
        declined: 0
        synced: 0
        updatedAt: Tools.dateToSec(new Date)
        extra: {
            var map = {
                title: dis.title,
                subtitle: dis.poet,
                image: dis.image,
                link: loader.link,
                verseText: dis.verseText
            };

            return Tools.variantToJson(map, true);
        }
    }

    Query.UserActions {
        id: faveActionQuery
        type: Query.UserActions.TypeFavorite
        poemId: dis.poemId
        poetId: dis.poetId
        declined: 0
        synced: 0
    }

    Query.UserActions {
        id: diaryQuery
        poemId: dis.poemId
        poetId: dis.id
        declined: 0
        synced: 0

        Component.onDestruction: { // Push Read duration as action
            if (clockTimer.count <= 10)
                return;

            var startHour = Math.floor(Tools.dateToSec(new Date(2020, 1, 1)) / 3600);
            var currentHour = Math.floor(Tools.dateToSec(new Date) / 3600);

            diaryQuery.type = Query.UserActions.TypeItemViewDiaryStart + (currentHour - startHour);
            if (diaryQuery.type < Query.UserActions.TypeItemViewDiaryStart || diaryQuery.type >= Query.UserActions.TypeItemViewDiaryEnd)
                return;

            diaryQuery.fetch();
            diaryQuery.value = (diaryQuery.value * 1) + clockTimer.count;
            diaryQuery.pushAction();
        }
    }

    Timer {
        id: userActionTimer
        interval: 10000
        repeat: false
        running: true
        onTriggered: {
            if (loader.refrshing) {
                restart();
                return;
            }

            viewActionQuery.pushAction()
            GlobalSignals.recentPoemsRefreshed()
            clockTimer.restart()
        }
    }

    Timer {
        id: clockTimer
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            if (Viewport.viewport.currentItem != dis)
                return;

            count++;
        }
        property int count: 10
    }

    form {
        viewCount: loader.views? Tools.translateNumbers(loader.views) : ""
        poet: GTranslations.translate(loader.poet)
        title: GTranslations.translate(loader.title)
        phrase: AsemanGlobals.phrase? loader.phrase : ""

        searchBtn.onClicked: Viewport.controller.trigger("float:/search?poetId=" + poetId)

        onNavigationClicked: {
            var properties = loader.categoriesModel.get(index);
            properties["navigData"] = loader.categoriesModel.data.slice(0, index+1);

            Viewport.controller.trigger(link, properties);
        }

        onSelectedToggled: {
            var oneExists = false;
            for (var i in form.selectedList)
                if (form.selectedList[i]) {
                    oneExists = true;
                    break;
                }

            if (!oneExists)
                form.selectMode = false;
        }

        onSelectModeChanged: {
            if (form.selectMode)
                BackHandler.pushHandler(form, function(){ form.selectMode = false; })
            else
                BackHandler.removeHandler(form)
        }

        onMenuRequest: {
            if (loader.refrshing)
                return;
            if (form.selectMode) {
                openGlobalMenu();
                return;
            }

            var pos = Qt.point(object.width/2, 0);
            var parent = object;
            while (parent && parent != dis) {
                pos.x += parent.x;
                pos.y += parent.y;
                parent = parent.parent;
            }

            var map = loader.versesModel.get(index);

            menuObject = Viewport.viewport.append(menuComponent, {"pointPad": pos, "index": index, "map": map, "verseText": map.text, "verseId": map.vorder}, "menu");
        }

        navigationRepeater.model: loader.categoriesModel

        menuBtn.onClicked: openGlobalMenu()
        backBtn.onClicked: ViewportType.open = false

        listView.model: loader.versesModel

        onMoreRequest: loader.more()
        onLessRequest: loader.less()
    }

    Component {
        id: globalMenuComponent
        MenuView {
            x: LayoutMirroring.enabled? 30 * Devices.density : parent.width - width - 30 * Devices.density
            y: form.menuBtnPosition.y + 30 * Devices.density
            width: 220 * Devices.density
            ViewportType.transformOrigin: {
                var y = -20 * Devices.density;
                var x = (LayoutMirroring.enabled? -20 * Devices.density : width + 20 * Devices.density);
                return Qt.point(x, y);
            }

            onItemClicked: {
                switch (index) {
                case 0:
                    form.selectMode = false;
                    Viewport.controller.trigger("bottomdrawer:/lists", {"selectMode": faveActionQuery.getLists(), "poetId": faveActionQuery.poetId,
                                                "catId": faveActionQuery.catId, "poemId": faveActionQuery.poemId, "verseId": faveActionQuery.verseId,
                                                "extra": viewActionQuery.extra});
                    break;
                case 1:
                    Devices.clipboard = dis.getText(false);
                    form.selectMode = false;
                    GlobalSignals.snackbarRequest(qsTr("Poem copied"));
                    break;
                case 2:
                    Viewport.controller.trigger("float:/sticker/export", {"poet": poet, "text": dis.getText(true)})
                    break;
                case 3:
                    Devices.share(dis.title, dis.getText(false));
                    form.selectMode = false;
                    break;
                case 4:
                    dis.form.selectMode = !dis.form.selectMode;
                    break;
                }

                ViewportType.open = false;
            }

            model: AsemanListModel {
                data: [
                    {
                        title: qsTr("Choose Lists"),
                        icon: "mdi_library",
                        enabled: true
                    },
                    {
                        title: qsTr("Copy"),
                        icon: "mdi_content_copy",
                        enabled: true
                    },
                    {
                        title: qsTr("Create Sticker"),
                        icon: "mdi_sticker",
                        enabled: !Devices.isIOS
                    },
                    {
                        title: qsTr("Share"),
                        icon: "mdi_share_variant",
                        enabled: true
                    },
                    {
                        title: qsTr("Select"),
                        icon: "mdi_select",
                        enabled: true
                    },
                ]
            }
        }
    }

    Component {
        id: menuComponent
        MenuView {
            id: menuItem
            x: pointPad.x - width/2
            y: Math.min(pointPad.y, dis.height - height - 100 * Devices.density)
            width: 220 * Devices.density
            ViewportType.transformOrigin: {
                var y = 30 * Devices.density + pointPad.y - menuItem.y;
                var x = width/2;
                return Qt.point(x, y);
            }

            property point pointPad
            property variant map
            property string verseText
            property int index
            property alias verseId: verseFaveActionQuery.verseId

            Query.UserActions {
                id: verseFaveActionQuery
                type: Query.UserActions.TypeFavorite
                poemId: dis.poemId
                poetId: dis.poetId
                declined: 0
                synced: 0
            }

            function getText(cleanText) {
                var text = "";
                for (var i=index; i<loader.versesModel.count; i++) {
                    var e = loader.versesModel.get(i);
                    text += e.text + "\n";
                    if (e.position === PoemVersesModel.PositionLeft || e.position === PoemVersesModel.PositionCenteredVerse2 || e.position === PoemVersesModel.PositionSingle) {
                        text += "\n";
                        break;
                    }
                }

                if (!cleanText) {
                    for (var j=1; j<loader.categoriesModel.count; j++) {
                        text += loader.categoriesModel.get(j).title
                        if (j < loader.categoriesModel.count-1)
                            text += ", ";
                        else
                            text += " - ";
                    }

                    text += poet;
                } else {
                    text = Tools.stringReplace(text, "\n+", "\n", true);
                }

                return text.trim();
            }

            onItemClicked: {
                var idx = menuItem.index;
                var poemLoader = loader;

                var map = {
                    title: dis.title,
                    subtitle: dis.poet,
                    image: dis.image,
                    link: loader.link,
                    verseText: dis.verseText,
                    verseId: verseId,
                    verseText: menuItem.verseText
                };

                var extra = Tools.variantToJson(map, true);

                switch (index) {
                case 0:
                    var poemText = getText(false);
                    poemText = Tools.stringReplace(poemText, "\n+", "\n", true);

                    Viewport.controller.trigger("float:/notes/add", {"poetId": verseFaveActionQuery.poetId,
                                                "catId": verseFaveActionQuery.catId, "poemId": verseFaveActionQuery.poemId,
                                                "verseId": verseFaveActionQuery.verseId, "poemText": poemText, "extra": extra}).saved.connect(function(text){
                        var item = poemLoader.versesModel.get(idx);
                        poemLoader.versesModel.remove(idx);

                        item.hasNote = (text.length? true : false);
                        poemLoader.versesModel.insert(idx, item);
                    });
                    break;

                case 1:
                    Viewport.controller.trigger("bottomdrawer:/lists", {"selectMode": verseFaveActionQuery.getLists(), "poetId": verseFaveActionQuery.poetId,
                                                "catId": verseFaveActionQuery.catId, "poemId": verseFaveActionQuery.poemId,
                                                "verseId": verseFaveActionQuery.verseId, "extra": extra}).saved.connect(function(lists){
                        var item = poemLoader.versesModel.get(idx);
                        poemLoader.versesModel.remove(idx);

                        item.hasList = false;
                        item.favorited = false;

                        lists.forEach(function(id){
                            if (id == Query.UserActions.TypeFavorite)
                                item.favorited = true;
                            else
                                item.hasList = true;
                        })
                        poemLoader.versesModel.insert(idx, item);
                    });
                    break;
                case 2:
                    Devices.clipboard = getText(false);
                    GlobalSignals.snackbarRequest(qsTr("Verse copied"));
                    break;
                case 3:
                    Viewport.controller.trigger("float:/sticker/export", {"poet": poet, "text": getText(true)})
                    break;
                case 4:
                    Devices.share(dis.title, getText(false));
                    break;
                }

                ViewportType.open = false;
            }

            model: AsemanListModel {
                data: [
                    {
                        title: qsTr("Note"),
                        icon: "mdi_note",
                        enabled: true
                    },
                    {
                        title: qsTr("Choose Lists"),
                        icon: "mdi_library",
                        enabled: true
                    },
                    {
                        title: qsTr("Copy"),
                        icon: "mdi_content_copy",
                        enabled: true
                    },
                    {
                        title: qsTr("Create Sticker"),
                        icon: "mdi_sticker",
                        enabled: !Devices.isIOS
                    },
                    {
                        title: qsTr("Share"),
                        icon: "mdi_share_variant",
                        enabled: true
                    },
                ]
            }
        }
    }

    function openGlobalMenu() {
        if (loader.refrshing)
            return;

        var map = loader.versesModel.get(0);
        dis.verseText = map.text

        menuObject = Viewport.viewport.append(globalMenuComponent, {}, "menu");
    }
}
