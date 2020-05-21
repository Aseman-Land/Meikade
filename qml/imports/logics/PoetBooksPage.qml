import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import views 1.0
import models 1.0
import micros 1.0

PoetBooksView {
    width: Constants.width
    height: Constants.height

    property alias id: catsModel.poetId
    property alias catId: catsModel.parentId
    property alias navigData: navigModel.data
    property string poet
    property string poetImage

    property string url
    property variant properties

    AsemanListModel {
        id: navigModel
        data: []
    }

    Component.onCompleted: avatar.source = Constants.thumbsBaseUrl + id + ".png"

    downloadingProgressIndicator.running: catsModel.offlineInstaller.uninstalling || catsModel.offlineInstaller.installing || catsModel.offlineInstaller.downloading
    downloadProgress: catsModel.offlineInstaller.size? (catsModel.offlineInstaller.downloadedBytes / catsModel.offlineInstaller.size) * 0.9 + 0.1 : 0.1
    downloadProgressBar.visible: !catsModel.offlineInstaller.uninstalling
    downloadProgressLabel.text: catsModel.offlineInstaller.installing? qsTr("Installing") : (catsModel.offlineInstaller.uninstalling? qsTr("Uninstalling") : qsTr("Downloading"))

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
            prp["poetImage"] = poetImage;

            Viewport.controller.trigger(link, prp);
        }
        model: CatsModel {
            id: catsModel
            cachePath: AsemanGlobals.cachePath + "/poetbook-" + poetId + "-" + parentId + ".cache"
        }
    }

    Component {
        id: menuComponent
        MenuView {
            x: LayoutMirroring.enabled? 30 * Devices.density : parent.width - 30 * Devices.density
            y: 40 * Devices.density + Devices.statusBarHeight
            width: 220 * Devices.density
            ViewportType.transformOrigin: Qt.point(-20 * Devices.density, (LayoutMirroring.enabled? -20 * Devices.density : width + 20 * Devices.density))

            onItemClicked: {
                switch (index) {
                case 0:
                    catsModel.offlineInstaller.install( !catsModel.offlineInstaller.installed );
                    break;
                }

                ViewportType.open = false;
            }

            model: AsemanListModel {
                data: [
                    {
                        title: catsModel.offlineInstaller.installed? qsTr("Disable Offline") : qsTr("Enable offline"),
                        icon: "mdi_download"
                    },
                    {
                        title: qsTr("Random poem"),
                        icon: "mdi_shuffle"
                    },
                    {
                        title: qsTr("Search on this poet"),
                        icon: "mdi_magnify"
                    }
                ]
            }
        }
    }
}
