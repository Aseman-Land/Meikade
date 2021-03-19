import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import queries 1.0 as Query
import views 1.0
import globals 1.0
import requests 1.0
import models 1.0
import micros 1.0

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

    Component.onCompleted: if (loader.poemId == 0) loader.random()
    Component.onDestruction: if (menuObject) menuObject.ViewportType.open = false

    MyPoemLoaderModel {
        id: loader
        poemId: dis.poemId
    }

    Timer {
        id: editTimer
        interval: 400
        repeat: false
        running: true
        onTriggered: if (loader.versesModel.count == 0) edit()
    }

    form {
        poet: MyUserRequest._fullname
        title: GTranslations.translate(loader.title)

        busyIndicator.visible: false
        selectable: false

        searchLabel.visible: false
        listView.bottomMargin: editColumn.height

        menuBtn.visible: previewText.length == 0
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

            menuObject = Viewport.viewport.append(menuComponent, {"pointPad": pos, "index": index, "map": map, "verseText": map.text, "verseId": map.vorder}, "menu");
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
        parent: dis.form
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8 * Devices.density
        y: mapListener.result.y + form.listView.footerItem.height
        spacing: 8 * Devices.density
        visible: previewText.length == 0

        Label {
            Layout.fillWidth: true
            Layout.topMargin: 4 * Devices.density
            font.pixelSize: 7 * Devices.fontDensity
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: qsTr("To edit poem touch below button.") + Translations.refresher
            opacity: 0.7
        }

        RoundButton {
            Layout.bottomMargin: 20 * Devices.density
            Layout.preferredWidth: editPoemRow.width + 60 * Devices.density
            Layout.alignment: Qt.AlignHCenter
            highlighted: true
            onClicked: edit()

            RowLayout {
                id: editPoemRow
                x: 30 * Devices.density
                anchors.verticalCenter: parent.verticalCenter

                Label {
                    font.pixelSize: 12 * Devices.fontDensity
                    font.family: MaterialIcons.family
                    text: MaterialIcons.mdi_feather
                    color: "#fff"
                }

                Label {
                    text: qsTr("Edit Poem") + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    color: "#fff"
                }
            }
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
                    break;
                case 1:
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
                        title: qsTr("Delete"),
                        icon: "mdi_delete",
                        enabled: true
                    },
                ]
            }
        }
    }

    function edit() {
        Viewport.controller.trigger("page:/mypoems/poem/edit",
                                            {"poemId": poemId,
                                             "categories": loader.categoriesModel.data})
    }

    function openGlobalMenu() {
        if (loader.refrshing)
            return;

        menuObject = Viewport.viewport.append(globalMenuComponent, {}, "menu");
    }
}
