import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.3
import queries 1.0 as Query
import globals 1.0
import requests 1.0
import models 1.0
import components 1.0
import "views"

PoemView {
    id: dis
    width: Constants.width
    height: Constants.height
    clip: true

    ViewportType.gestureWidth: menuObject? 0 : 150 * Devices.density

    property string url

    property alias id: loader.poetId
    property alias catId: loader.catId
    property alias poemId: loader.poemId

    property alias title: loader.title
    property alias poet: loader.poet
    property alias subtitle: loader.poet

    property bool editMode: true
    property alias previewText: loader.previewText
    property alias previewType: loader.previewType

    onPoemIdChanged: form.selectMode = false;

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

    Component.onCompleted: {
        RequestsModel.refreshing;
        if (loader.poemId == 0)
            loader.random()
    }
    Component.onDestruction: if (menuObject) menuObject.ViewportType.open = false

    MyPoemLoaderModel {
        id: loader
        poemId: dis.poemId
    }

    Query.UserActions {
        id: loadAction
    }

    Timer {
        id: editTimer
        interval: 400
        repeat: false
//        running: true
        onTriggered: if (loader.versesModel.count == 0) edit()
    }

    form {
        poet: MyUserRequest._fullname
        title: GTranslations.translate(loader.title)

        busyIndicator.visible: false
        selectable: false

        searchLabel.visible: false
        listView.bottomMargin: editColumn.height

        menuBtn.visible: previewText.length == 0 && editMode
        onNavigationClicked: {
            if (previewText.length)
                return;

            var properties = loader.categoriesModel.get(index);
            properties["navigData"] = loader.categoriesModel.data.slice(0, index+1);

            Viewport.controller.trigger(link, properties);
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

//            menuObject = Viewport.viewport.append(menuComponent, {"pointPad": pos, "index": index, "map": map, "verseText": map.text, "verseId": map.vorder}, "menu");
        }

        navigationRepeater.model: loader.categoriesModel

        menuBtn.onClicked: openGlobalMenu()
        backBtn.onClicked: ViewportType.open = false

        listView.model: loader.versesModel
    }

    PointMapListener {
        id: mapListener
        source: form.listView.footerItem
        dest: dis
    }

    ColumnLayout {
        id: editColumn
        parent: dis.form.extraScene
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8 * Devices.density
        y: mapListener.result.y + form.listView.footerItem.height
        spacing: 8 * Devices.density
        visible: previewText.length == 0 && editMode

        MLabel {
            Layout.fillWidth: true
            Layout.topMargin: 4 * Devices.density
            font.pixelSize: 7 * Devices.fontDensity
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: qsTr("To edit poem touch below button.") + Translations.refresher
            opacity: 0.7
        }

        MButton {
            Layout.alignment: Qt.AlignHCenter
            highlighted: true
            onClicked: edit()
            iconPixelSize: 12 * Devices.fontDensity
            icon: MaterialIcons.mdi_feather
            text: qsTr("Edit Poem") + Translations.refresher
        }

        MButton {
            Layout.bottomMargin: 20 * Devices.density
            Layout.alignment: Qt.AlignHCenter
            highlighted: true
            visible: Bootstrap.initialized
            onClicked: publish()
            iconPixelSize: 12 * Devices.fontDensity
            icon: MaterialIcons.mdi_publish
            text: qsTr("Publish") + Translations.refresher
        }
    }

    PointMapListener {
        id: listener
        source: dis
        dest: Viewport.viewport
    }

    UnpublishPoemRequest {
        id: ubpubReq
        allowGlobalBusy: true
        category_id: loader.catId
        poem_id: loader.poemId
        onSuccessfull: GlobalSignals.snackbarRequest(qsTr("Poem unpublished successfully"));
    }

    Component {
        id: globalMenuComponent
        MenuView {
            x: listener.result.x + (LayoutMirroring.enabled? 30 * Devices.density : dis.width - width - 30 * Devices.density)
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
                    Viewport.controller.trigger("dialog:/mypoems/poem/add", {"actionId": loader.poemId})
                    break;
                case 1:
                    var properties = {
                        "title": qsTr("Delete"),
                        "body": qsTr("Do you realy want to unpublish this poem? Not that you must submit review request for the republish."),
                        "buttons": [qsTr("Cancel"), qsTr("Unpublish")]
                    };

                    var poemId = loader.poemId;
                    var action = loadAction;
                    var page = dis
                    var obj = Viewport.controller.trigger("dialog:/general/error", properties);
                    obj.itemClicked.connect(function(idx) {
                        switch (idx) {
                        case 0: // Cancel
                            break;

                        case 1: // Unpublish
                            ubpubReq.doRequest();
                            break;
                        }
                        obj.ViewportType.open = false;
                    });
                    break;

                case 2:
                    var properties = {
                        "title": qsTr("Delete"),
                        "body": qsTr("Do you realy want to delete this poem?"),
                        "buttons": [qsTr("Cancel"), qsTr("Delete")]
                    };

                    var poemId = loader.poemId;
                    var action = loadAction;
                    var page = dis
                    var obj = Viewport.controller.trigger("dialog:/general/error", properties);
                    obj.itemClicked.connect(function(idx) {
                        switch (idx) {
                        case 0: // Cancel
                            break;

                        case 1: // Delete
                            action.deleteBook(poemId)
                            page.ViewportType.open = false;
                            GlobalSignals.poemsRefreshed();
                            GlobalSignals.booksRefreshed();
                            break;
                        }
                        obj.ViewportType.open = false;
                    });
                    break;
                }

                ViewportType.open = false;
            }

            model: AsemanListModel {
                data: [
                    {
                        title: qsTr("Rename"),
                        icon: "mdi_pencil",
                        enabled: true
                    },
                    {
                        title: qsTr("Unpublish"),
                        icon: "mdi_undo",
                        enabled: RequestsModel.hash.test(loader.poetId, loader.catId, loader.poemId, 0, 0)
                    },
                    {
                        title: qsTr("Delete"),
                        icon: "mdi_delete",
                        enabled: true
                    },
                ]
            }
        }
    }

    function edit() {
        Viewport.controller.trigger("stack:/mypoems/poem/edit",
                                            {"poemId": poemId,
                                             "categories": loader.categoriesModel.data})
    }

    function publish() {
        if (AsemanGlobals.accessToken.length == 0) {
            Viewport.controller.trigger("popup:/auth/float", {})
            return;
        }
        Viewport.controller.trigger("popup:/mypoems/publish", {"poemId": poemId})
    }

    function openGlobalMenu() {
        if (loader.refrshing)
            return;

        menuObject = Viewport.viewport.append(globalMenuComponent, {}, "menu");
    }
}


