import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import Meikade 1.0
import queries 1.0
import components 1.0
import globals 1.0
import models 1.0
import "views"

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
    avatar.source: AsemanGlobals.testPoetImagesDisable? "" : loader.image

    AsemanListModel {
        id: navigModel
        data: [properties]
    }

    PoetLoaderModel {
        id: loader
        booksModel.cachePath: AsemanGlobals.cachePath + "/poet-" + poetId + ".cache"
    }

    UserActions {
        id: viewActionQuery
        type: UserActions.TypePoetViewDate
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
            viewActionQuery.pushAction()
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
        onLinkRequest: function(link, properties) {
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
                    loader.offlineInstaller.checkAndInstall( !loader.offlineInstaller.installed );
                    break;
                case 1:
                    Viewport.controller.trigger("page:/poem/random?poetId=" + dis.id);
                    break;
                case 2:
                    Viewport.controller.trigger("float:/search?poetId=" + dis.id);
                    break;
                }

                ViewportType.open = false;
            }

            model: AsemanListModel {
                data: [
                    {
                        title: loader.offlineInstaller.installed? qsTr("Disable Offline") : qsTr("Enable offline"),
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


