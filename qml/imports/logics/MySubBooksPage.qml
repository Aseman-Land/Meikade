import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import AsemanQml.Viewport 2.0
import queries 1.0 as Query
import globals 1.0
import views 1.0
import models 1.0
import micros 1.0
import requests 1.0

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

    premiumMsg: {
        if (Subscription.premium || Subscription.mypoemsLimits < 0 || !Bootstrap.initialized)
            return "";

        var tgLink = "<a href='https://t.me/poshtibanimoon'>" + qsTr("Click Here") +"</a>";
        if (Bootstrap.payment && Bootstrap.trusted)
            return GTranslations.translate( qsTr("You create %1 poem from %2 poems, Allowed to create using non-premium account.").arg(poemsCount).arg(Subscription.mypoemsLimits) )
        else
            return GTranslations.translate( qsTr("You create %1 poems from %2 poems. for more information contact us on telegram:").arg(poemsCount).arg(Subscription.mypoemsLimits) ) + " " + tgLink
    }

    onPremiumBuyRequest: Viewport.controller.trigger("bottomdrawer:/account/premium/buy")
    Component.onCompleted: {
        RequestsModel.refreshing;
        premiumTimer.restart()
    }

    avatar.header: MyUserRequest.headers
    avatar.source: MyUserRequest._image

    Connections {
        target: GlobalSignals
        onPoemsRefreshed: premiumTimer.restart()
    }

    Timer {
        id: premiumTimer
        interval: 100
        repeat: false
        onTriggered: poemsCount = loadAction.getMyPoemsCount()
    }

    AsemanListModel {
        id: navigModel
        data: []
    }

    Connections {
        target: GlobalSignals
        onBooksRefreshed: load()
    }

    onBookIdChanged: Qt.callLater(load)

    function load() {
        var books = loadAction.getBooksItem(bookId);
        if (books.length == 0)
            return;

        let r = books[0];
        title = r.value;

        var data = Tools.toVariantList(navigData);
        data[data.length-1].title = title;

        navigData = data;
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

    Query.UserActions {
        id: loadAction
        poemId: 0
        poetId: 0
        declined: 0
    }

    PointMapListener {
        id: listener
        source: dis
        dest: Viewport.viewport
    }

    Component {
        id: menuComponent
        MenuView {
            id: menu
            x: listener.result.x + (LayoutMirroring.enabled? 30 * Devices.density : dis.width - 30 * Devices.density - width)
            y: 40 * Devices.density + Devices.statusBarHeight
            width: 220 * Devices.density
            ViewportType.transformOrigin: Qt.point((LayoutMirroring.enabled? -20 * Devices.density : width + 20 * Devices.density), -20 * Devices.density)

            onItemClicked: {
                switch (index) {
                case 0:
                    Viewport.controller.trigger("dialog:/mypoems/add", {"actionId": bookModel.bookId})
                    break;

                case 1:
                    break;

                case 2:
                    var properties = {
                        "title": qsTr("Delete"),
                        "body": qsTr("Do you realy want to delete this book? Not that all sub books and poems will deleted."),
                        "buttons": [qsTr("Cancel"), qsTr("Delete")]
                    };

                    var bookId = bookModel.bookId;
                    var action = loadAction;
                    var page = dis
                    var obj = Viewport.controller.trigger("dialog:/general/error", properties);
                    obj.itemClicked.connect(function(idx) {
                        switch (idx) {
                        case 0: // Cancel
                            break;

                        case 1: // Delete
                            action.deleteBookRecursively(bookId)
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
                        enabled: RequestsModel.hash.test(bookId, 0, 0, 0, 0)
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
}
