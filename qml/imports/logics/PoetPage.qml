import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.MaterialIcons 2.0
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

            model: ListModel {
                ListElement {
                    title: qsTr("Enable offline")
                    icon: "mdi_download"
                }
                ListElement {
                    title: qsTr("Random poem")
                    icon: "mdi_shuffle"
                }
                ListElement {
                    title: qsTr("Search on this poet")
                    icon: "mdi_magnify"
                }
            }
        }
    }
}
