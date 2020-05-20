import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
import Meikade 1.0
import queries 1.0
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
    property alias id: catsModel.poetId
    property alias navigData: navigModel.data


    AsemanListModel {
        id: navigModel
        data: [properties]
    }

    Behavior on downloadProgress {
        NumberAnimation { duration: 300 }
    }

    downloadingProgressIndicator.running: catsModel.offlineInstaller.uninstalling || catsModel.offlineInstaller.installing || catsModel.offlineInstaller.downloading
    downloadProgress: catsModel.offlineInstaller.size? (catsModel.offlineInstaller.downloadedBytes / catsModel.offlineInstaller.size) * 0.9 + 0.1 : 0.1
    downloadProgressBar.visible: !catsModel.offlineInstaller.uninstalling
    downloadProgressLabel.text: catsModel.offlineInstaller.installing? qsTr("Installing") : (catsModel.offlineInstaller.uninstalling? qsTr("Uninstalling") : qsTr("Downloading"))

    settingsBtn.onClicked: Viewport.viewport.append(menuComponent, {}, "menu")
    bioBtn.onClicked: Viewport.controller.trigger("popup:/poet/bio", {"link": properties.details.wikipedia})
    menuBtn.onClicked: ViewportType.open = false

    gridView {
        onLinkRequest: {
            var navigData = navigModel.data;
            navigData[navigData.length] = Tools.toVariantMap(properties);

            var prp = Tools.toVariantMap(properties);
            prp["navigData"] = navigData;
            prp["poet"] = dis.title;
            prp["poetImage"] = dis.image;

            Viewport.controller.trigger(link, prp);
        }
        model: CatsModel {
            id: catsModel
            cachePath: AsemanGlobals.cachePath + "/poet-" + poetId + ".cache"
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
