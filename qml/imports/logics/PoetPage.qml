import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import Meikade 1.0
import queries 1.0
import queries 1.0 as Query
import views 1.0
import micros 1.0
import globals 1.0
import models 1.0

PoetView {
    id: dis
    width: Constants.width
    height: Constants.height
    clip: true

    property string url
    property variant properties
    property alias id: loader.poetId
    property alias navigData: navigModel.data

    property alias title: loader.name
    property alias image: loader.image

    profileLabel.text: loader.name
    avatar.source: loader.image

    AsemanListModel {
        id: navigModel
        data: [properties]
    }

    PoetLoaderModel {
        id: loader
        booksModel.cachePath: AsemanGlobals.cachePath + "/poet-" + poetId + ".cache"
    }

    Query.UserActions {
        id: viewActionQuery
        type: Query.UserActions.TypePoetViewDate
        poemId: 0
        poetId: dis.id
        declined: 0
        synced: 0
        updatedAt: Tools.dateToSec(new Date)
        extra: {
            var map = {
                title: title,
                image: image,
                link: url
            }

            return Tools.variantToJson(map, true);
        }
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

    bioBtn.onClicked: Viewport.controller.trigger("float:/poet/bio", {"link": loader.wikipedia, "text": loader.description})

    progressBar.running: loader.offlineInstaller.uninstalling || loader.offlineInstaller.installing || loader.offlineInstaller.downloading
    progressBar.progress: loader.offlineInstaller.size? (loader.offlineInstaller.downloadedBytes / loader.offlineInstaller.size) * 0.9 + 0.1 : 0.1
    progressBar.nonProgress: !loader.offlineInstaller.uninstalling
    progressBar.label: loader.offlineInstaller.installing? qsTr("Installing") : (loader.offlineInstaller.uninstalling? qsTr("Uninstalling") : qsTr("Downloading"))

    settingsBtn.onClicked: Viewport.viewport.append(menuComponent, {}, "menu")
    menuBtn.onClicked: ViewportType.open = false

    gridView {
        onLinkRequest: {
            var navigData = dis.navigData;
            navigData[navigData.length] = Tools.toVariantMap(properties);

            var prp = Tools.toVariantMap(properties);
            prp["navigData"] = navigData;
            prp["poet"] = dis.title;
            prp["poetImage"] = dis.image;

            Viewport.controller.trigger(link, prp);
        }

        model: loader.booksModel
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
                    loader.offlineInstaller.install( !loader.offlineInstaller.installed );
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
                        title: loader.offlineInstaller.installed? qsTr("Disable Offline") : qsTr("Enable offline"),
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
