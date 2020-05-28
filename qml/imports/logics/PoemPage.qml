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

    ViewportType.gestureWidth: 150 * Devices.density

    property string url
    property variant properties

    property string poetImage
    property string verseText

    property int verseId

    property alias id: dis.poetId
    property int poetId
    property alias poemId: poemModel.poemId
    property alias navigData: navigModel.data

    onPoemIdChanged: form.selectMode = false;
    onVerseIdChanged: highlightTimer.restart()

    onChangeRequest: {
        url = link;
        dis.title = title;
        properties.title = title;
        properties.subtitle = subtitle;

        var poemIds = Tools.stringRegExp(link, "poemId\\=(\\d+)", false);
        var ids = Tools.stringRegExp(link, "id\\=(\\d+)", false);

        var poemId = poemIds[0][1];

        poemModel.cachePath = "";
        poemModel.clear();
        poemModel.cachePath = AsemanGlobals.cachePath + "/poem-" + poemId + ".cache";

        dis.poemId = poemIds[0][1];
        dis.id = ids[0][1];

        var navigData = Tools.toVariantList(dis.navigData)
        navigData[navigData.length-1].title = title;
        navigData[navigData.length-1].link = link;

        dis.navigData = navigData;

        properties.navigData = navigData;
        properties.neighbors = Tools.toVariantList(neighbors);
        properties.neighborsIndex = neighborsIndex;

        properties = Tools.toVariantMap(properties)

        userActionTimer.restart();
    }

    function getText(cleanText) {
        var text = "";
        for (var i=0; i<poemModel.count; i++) {
            var e = poemModel.get(i);
            if (form.selectMode && form.selectedList.length) {
                if (((e.position !== PoemVersesModel.PositionLeft && e.position !== PoemVersesModel.PositionCenteredVerse2) || !form.selectedList[i-1]) &&
                    ((e.position !== PoemVersesModel.PositionRight && e.position !== PoemVersesModel.PositionCenteredVerse1) || !form.selectedList[i]))
                    continue;
            }

            text += e.text + "\n";
            if (e.position === PoemVersesModel.PositionLeft || e.position === PoemVersesModel.PositionCenteredVerse2)
                text += "\n";
        }

        if (!cleanText) {
            for (var j=1; j<navigModel.count; j++) {
                text += navigModel.get(j).title
                if (j < navigModel.count-1)
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

    Timer {
        id: highlightTimer
        interval: 500
        repeat: false
        onTriggered: {
            for (var i=0; i<poemModel.count; i++)
                if (verseId == poemModel.get(i).vorder) {
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

    AsemanListModel {
        id: navigModel
        data: []
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
            var map = Tools.toVariantMap(properties);
            map["title"] = title;
            map["subtitle"] = poet;
            map["image"] = poetImage;
            map["link"] = url;
            map["verseText"] = verseText;
            map["verseId"] = 0;

            return Tools.variantToJson(map);
        }
    }

    Query.UserActions {
        id: faveActionQuery
        type: Query.UserActions.TypeFavorite
        poemId: dis.poemId
        poetId: dis.id
        declined: 0
        synced: 0
    }

    Timer {
        id: userActionTimer
        interval: 10000
        repeat: false
        running: true
        onTriggered: {
            viewActionQuery.push()
            GlobalSignals.recentPoemsRefreshed()
        }
    }

    form {
        onNavigationClicked: {
            if (index + 1 == navigModel.count)
                return;

            var properties = navigModel.get(index);
            properties["navigData"] = navigModel.data.slice(0, index+1);

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
            var pos = Qt.point(object.width/2, 0);
            var parent = object;
            while (parent && parent != dis) {
                pos.x += parent.x;
                pos.y += parent.y;
                parent = parent.parent;
            }

            var map = poemModel.get(index);

            Viewport.viewport.append(menuComponent, {"pointPad": pos, "index": index, "map": map, "verseText": map.text, "verseId": map.vorder}, "menu");
        }

        navigationRepeater.model: navigModel

        menuBtn.onClicked: {
            faveActionQuery.declined = 0;
            faveActionQuery.updatedAt = 0;
            faveActionQuery.fetch();

            var map = poemModel.get(0);
            dis.verseText = map.text

            Viewport.viewport.append(globalMenuComponent, {}, "menu");
        }
        backBtn.onClicked: ViewportType.open = false

        listView.model: PoemVersesModel {
            id: poemModel
            cachePath: AsemanGlobals.cachePath + "/poem-" + poemId + ".cache"
        }
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
                    faveActionQuery.declined = (faveActionQuery.updatedAt && !faveActionQuery.declined? 1 : 0);
                    faveActionQuery.updatedAt = Tools.dateToSec(new Date);
                    faveActionQuery.extra = viewActionQuery.extra
                    faveActionQuery.push();
                    form.selectMode = false;
                    GlobalSignals.snackbarRequest(faveActionQuery.declined? qsTr("Poem Unfavorited") : qsTr("Poem favorited"));
                    GlobalSignals.favoritesRefreshed();
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
                        title: faveActionQuery.updatedAt && !faveActionQuery.declined? qsTr("Remove Bookmarks") : qsTr("Add to Bookmarks"),
                        icon: faveActionQuery.updatedAt && !faveActionQuery.declined? "mdi_bookmark" : "mdi_bookmark_outline"
                    },
                    {
                        title: qsTr("Copy"),
                        icon: "mdi_content_copy"
                    },
                    {
                        title: qsTr("Create Sticker"),
                        icon: "mdi_sticker"
                    },
                    {
                        title: qsTr("Share"),
                        icon: "mdi_share_variant"
                    },
                    {
                        title: qsTr("Select"),
                        icon: "mdi_select"
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
                poetId: dis.id
                declined: 0
                synced: 0
                extra: {
                    var map = Tools.jsonToVariant(viewActionQuery.extra)
                    map["verseId"] = verseId;
                    map["verseText"] = menuItem.verseText;
                    return Tools.variantToJson(map);
                }
                Component.onCompleted: fetch()
            }

            function getText(cleanText) {
                var text = "";
                for (var i=index; i<poemModel.count; i++) {
                    var e = poemModel.get(i);
                    text += e.text + "\n";
                    if (e.position === PoemVersesModel.PositionLeft || e.position === PoemVersesModel.PositionCenteredVerse2 || e.position === PoemVersesModel.PositionSingle) {
                        text += "\n";
                        break;
                    }
                }

                if (!cleanText) {
                    for (var j=1; j<navigModel.count; j++) {
                        text += navigModel.get(j).title
                        if (j < navigModel.count-1)
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

            onItemClicked: {
                switch (index) {
                case 0:
                    verseFaveActionQuery.declined = (verseFaveActionQuery.updatedAt && !verseFaveActionQuery.declined? 1 : 0);
                    verseFaveActionQuery.updatedAt = Tools.dateToSec(new Date);
                    verseFaveActionQuery.push();
                    GlobalSignals.snackbarRequest(verseFaveActionQuery.declined? qsTr("Verse Unfavorited") : qsTr("Verse favorited"));
                    GlobalSignals.favoritesRefreshed();
                    break;
                case 1:
                    Devices.clipboard = getText(false);
                    GlobalSignals.snackbarRequest(qsTr("Verse copied"));
                    break;
                case 2:
                    Viewport.controller.trigger("float:/sticker/export", {"poet": poet, "text": getText(true)})
                    break;
                case 3:
                    Devices.share(dis.title, getText(false));
                    break;
                }

                ViewportType.open = false;
            }

            model: AsemanListModel {
                data: [
                    {
                        title: verseFaveActionQuery.updatedAt && !verseFaveActionQuery.declined? qsTr("Remove Bookmarks") : qsTr("Add to Bookmarks"),
                        icon: verseFaveActionQuery.updatedAt && !verseFaveActionQuery.declined? "mdi_bookmark" : "mdi_bookmark_outline"
                    },
                    {
                        title: qsTr("Copy"),
                        icon: "mdi_content_copy"
                    },
                    {
                        title: qsTr("Create Sticker"),
                        icon: "mdi_sticker"
                    },
                    {
                        title: qsTr("Share"),
                        icon: "mdi_share_variant"
                    },
                ]
            }
        }
    }
}
