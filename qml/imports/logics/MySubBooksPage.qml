import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import queries 1.0 as Query
import globals 1.0
import views 1.0
import models 1.0
import micros 1.0

PoetBooksView {
    id: dis
    width: Constants.width
    height: Constants.height
    readWriteMode: true
    poemAddMode: !bookModel.hasBook
    bookAddMode: !bookModel.hasPoem

    property alias bookId: bookModel.bookId

    property alias navigData: navigModel.data
    property string title
    property string poet
    property string poetImage

    property string url
    property variant properties

    AsemanListModel {
        id: navigModel
        data: []
    }

    progressBar.running: false

    menuBtn.onClicked: Viewport.viewport.append(menuComponent, {}, "menu")
    headerBtn.onClicked: ViewportType.open = false

    navigationRepeater.model: navigModel

    onNavigationClicked: {
        if (index + 1 == navigModel.count)
            return;

        var properties = navigModel.get(index);
        properties["navigData"] = navigModel.data.slice(0, index+1);

        Viewport.controller.trigger(link, properties)
    }

    listView {
        onLinkRequest: {
            var navigData = navigModel.data;
            navigData[navigData.length] = Tools.toVariantMap(properties);

            var neighborsIndex = 0;
            var neighbors = new Array;
            try {
                for (var i in catsModel.data) {
                    var item = catsModel.data[i];
                    for (var j in item.modelData) {
                        var unit = item.modelData[j];
                        if (unit.link.indexOf("poemId=") <= 0)
                            continue;

                        if (unit.link == link)
                            neighborsIndex = neighbors.length;

                        neighbors[neighbors.length] = {"title": unit.title, "link": unit.link, "subtitle": unit.subtitle};
                    }
                }
            } catch (e) {}

            var prp = Tools.toVariantMap(properties);
            prp["navigData"] = navigData;
            prp["neighbors"] = neighbors;
            prp["neighborsIndex"] = neighborsIndex;
            prp["poet"] = poet;
            prp["subtitle"] = poet;
            prp["poetImage"] = poetImage;

            Viewport.controller.trigger(link, prp);
        }

        model: BooksModel {
            id: bookModel
        }
    }

    Component {
        id: menuComponent
        MenuView {
            x: LayoutMirroring.enabled? 30 * Devices.density : parent.width - 30 * Devices.density - width
            y: 40 * Devices.density + Devices.statusBarHeight
            width: 220 * Devices.density
            ViewportType.transformOrigin: Qt.point((LayoutMirroring.enabled? -20 * Devices.density : width + 20 * Devices.density), -20 * Devices.density)

            onItemClicked: {
                switch (index) {
                case 0:
                    break;
                case 1:
                    Viewport.controller.trigger("page:/poem/random?poetId=" + dis.id + "&catId=" + dis.catId);
                    break;
                case 2:
                    Viewport.controller.trigger("float:/search?poetId=" + dis.id)
                    break;
                }

                ViewportType.open = false;
            }

            model: AsemanListModel {
                data: [
                    {
                        title: qsTr("Enable offline"),
                        icon: "mdi_download",
                        enabled: true
                    },
                    {
                        title: qsTr("Random poem"),
                        icon: "mdi_shuffle",
                        enabled: true
                    },
                    {
                        title: qsTr("Search on this poet"),
                        icon: "mdi_magnify",
                        enabled: true
                    }
                ]
            }
        }
    }
}
