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

    property alias id: catsModel.poetId
    property alias catId: catsModel.parentId
    property variant navigData
    property string title
    property string poet: subtitle
    property string poetImage: "https://meikade.com/offlines/thumbs/" + id + ".png"
    property string subtitle

    property string url
    property variant properties

    onNavigDataChanged: if (navigData.length) navigModel.data = navigData;

    AsemanListModel {
        id: navigModel
        data: [
            {
                "title": subtitle,
                "image": poetImage,
                "id": id,
                "link": "page:/poet?id=" + id,
            },
            {
                "title": title,
                "image": poetImage,
                "id": catId,
                "link": url,
            },
        ]
    }

    Query.UserActions {
        id: viewActionQuery
        type: Query.UserActions.TypeCatViewDate
        poemId: 0
        poetId: dis.id
        catId: dis.catId
        declined: 0
        synced: 0
        updatedAt: Tools.dateToSec(new Date)
        extra: {
            var map = Tools.toVariantMap(properties);
            map["title"] = dis.title;
            map["subtitle"] = poet;
            map["image"] = poetImage;
            map["link"] = url;

            return Tools.variantToJson(map, true);
        }
    }

    Timer {
        id: userActionTimer
        interval: 10000
        repeat: false
        running: true
        onTriggered: {
            viewActionQuery.pushAction()
            GlobalSignals.recentPoemsRefreshed()
        }
    }

    Component.onCompleted: avatar.source = AsemanGlobals.testPoetImagesDisable? "" : Constants.thumbsBaseUrl + id + ".png"

    progressBar.running: catsModel.offlineInstaller.uninstalling || catsModel.offlineInstaller.installing || catsModel.offlineInstaller.downloading
    progressBar.progress: catsModel.offlineInstaller.size? (catsModel.offlineInstaller.downloadedBytes / catsModel.offlineInstaller.size) * 0.9 + 0.1 : 0.1
    progressBar.nonProgress: !catsModel.offlineInstaller.uninstalling
    progressBar.label: catsModel.offlineInstaller.installing? qsTr("Installing") : (catsModel.offlineInstaller.uninstalling? qsTr("Uninstalling") : qsTr("Downloading"))

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
        onMoreRequest: catsModel.more()
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
        model: CatsModel {
            id: catsModel
            cachePath: AsemanGlobals.cachePath + "/poetbook-" + poetId + "-" + parentId + ".cache"
        }
    }

    PointMapListener {
        id: listener
        source: dis
        dest: Viewport.viewport
    }

    Component {
        id: menuComponent
        MenuView {
            x: listener.result.x + (LayoutMirroring.enabled? 30 * Devices.density : dis.width - 30 * Devices.density - width)
            y: 40 * Devices.density + Devices.statusBarHeight
            width: 220 * Devices.density
            ViewportType.transformOrigin: Qt.point((LayoutMirroring.enabled? -20 * Devices.density : width + 20 * Devices.density), -20 * Devices.density)

            onItemClicked: {
                switch (index) {
                case 0:
                    catsModel.offlineInstaller.checkAndInstall( !catsModel.offlineInstaller.installed );
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
                        title: catsModel.offlineInstaller.installed? qsTr("Disable Offline") : qsTr("Enable offline"),
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
