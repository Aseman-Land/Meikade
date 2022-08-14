pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0

ViewportController {
    id: viewController

    property int waitCount: 0
    property variant waitObj

    readonly property bool tabletMode: viewController.viewport && viewController.viewport.width > viewController.viewport.height

    onWaitCountChanged: {
        if (waitCount > 0) {
            if (!waitObj) waitObj = trigger("dialog:/wait");
        } else {
            if (waitObj) waitObj.close()
        }
    }

    ViewportControllerRoute {
        route: /\w+\:\/account\/premium\/buy/
        source: "qrc:/qml/premium/routes/PremiumConfirmRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/settings/
        source: "qrc:/qml/general/routes/SettingsRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/settings\/theme/
        source: "qrc:/qml/general/routes/ThemeWizardRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/contactus/
        source: "qrc:/qml/general/routes/ContactRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/changelogs/
        source: "qrc:/qml/general/routes/ChangelogsRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/messages/
        source: "qrc:/qml/messages/routes/MessagesRoute.qml"
        viewportType: "popup"
    }

    ViewportControllerRoute {
        route: /\w+\:\/inbox/
        source: "qrc:/qml/messages/routes/InboxRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/syncs/
        source: "qrc:/qml/general/routes/SyncRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems/
        source: "qrc:/qml/poet/routes/MyBooksRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems\/add(?:\?.*bookId\=.+)?/
        source: "qrc:/qml/mypoems/routes/AddBookRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems\/poem\/add(?:\?.*bookId\=.+)?/
        source: "qrc:/qml/mypoems/routes/AddPoemRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems\/poem\/edit(?:\?.*bookId\=.+)?/
        source: "qrc:/qml/mypoems/routes/EditPoemRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems(?:\?.*bookId\=.+)?/
        source: "qrc:/qml/poet/routes/MySubBooksRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems\/poem(?:\?.*poemId\=.+)?/
        source: "qrc:/qml/poems/routes/MyPoemRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems\/publish(?:\?poemId=.+)?/
        source: "qrc:/qml/publish/routes/PublishRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poem\/random(?:\?.+)?/
        source: "qrc:/qml/poems/routes/PoemRoute.qml"
//        source: "qrc:/qml/poems/routes/RandomPoemRoute.qml"
//        viewportType: "none"
    }

    ViewportControllerRoute {
        route: /\w+\:\/web\?link=.+/
        source: "qrc:/qml/general/routes/WebBrowserRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poet(?:\?.*catId\=.+)?/
        source: "qrc:/qml/poet/routes/PoetBooksRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/poet(?:\?.*poemId\=.+)?/
        source: "qrc:/qml/poems/routes/PoemRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poet(?:\?.+)?/
        source: "qrc:/qml/poet/routes/PoetRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/search(?:\?.+)?/
        source: "qrc:/qml/search/routes/SearchRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/search\/smart\-about(?:\?.+)?/
        source: "SearchSmartqrc:/qml/general/routes/AboutRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poet\/bio(?:\?.+)?/
        source: "qrc:/qml/poet/routes/PoetBioRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poets(?:\?.+)?/
        source: "qrc:/qml/poet/routes/PoetsListRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/lists(?:\?.+)?/
        source: "qrc:/qml/lists/routes/ListsRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/lists\/single(?:\?.+)?/
        source: "qrc:/qml/lists/routes/SingleListRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/lists\/online(?:\?.+)?/
        source: "qrc:/qml/lists/routes/OnlineListRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/lists\/add(?:\?.+)?/
        source: "qrc:/qml/lists/routes/AddListRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/lists\/delete(?:\?.+)?/
        source: "qrc:/qml/lists/routes/DeleteListRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/notes(?:\?.+)?/
        source: "qrc:/qml/notes/routes/NotesRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/notes\/add(?:\?.+)?/
        source: "qrc:/qml/notes/routes/AddNoteRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/offline\/manage/
        source: "qrc:/qml/poet/routes/ManageOfflinePoetsRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/favorites/
//        route: /\w+\:\/poets\/top/
        source: "qrc:/qml/poet/routes/TopPoetsRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/recents/
        source: "qrc:/qml/poems/routes/MostReadedPoemsRoute.qml"
        viewportType: tabletMode? "popup" : "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/abouts/
        source: "qrc:/qml/general/routes/AboutRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/poem\/hafiz_faal/
        source: "qrc:/qml/randoms/routes/HafizFaalRoute.qml"
        viewportType: tabletMode? "popup" : "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/auth\/float/
        source: "qrc:/qml/auth/routes/AuthRoute.qml"
        viewportType: tabletMode? "popup" : "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/auth\/changePassword(?:\?.+)?/
        source: "qrc:/qml/auth/routes/ChangePasswordRoute.qml"
        viewportType: tabletMode? "popup" : "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/auth\/changeName(?:\?.+)?/
        source: "qrc:/qml/auth/routes/ChangeNameRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/auth\/changeBio(?:\?.+)?/
        source: "qrc:/qml/auth/routes/ChangeBioRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/sticker\/export/
        source: "qrc:/qml/old/routes/StickerRoute.qml"
        viewportType: tabletMode? "popup" : "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/helpers\/poem\/swipe/
        source: "qrc:/qml/helpers/routes/PoemSwipeHelperRoute.qml"
    }

    ViewportControllerRoute {
        route: /dialog:\/general\/error.*/
        source: "qrc:/qml/dialogs/routes/ErrorDialogRoute.qml"
    }

    ViewportControllerRoute {
        route: /dialog:\/wait/
        source: "WaitDialogRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+:\/volcano\/deposit/
        source: "qrc:/qml/volcano/DepositDialog.qml"
        viewportType: "bottomdrawer"
    }

    ViewportControllerRoute {
        route: /\w+:\/volcano\/withdraw/
        source: "qrc:/qml/volcano/WithdrawDialog.qml"
        viewportType: "bottomdrawer"
    }

    ViewportControllerRoute {
        route: /\w+:\/volcano\/payments/
        source: "qrc:/qml/volcano/PaymentsDialog.qml"
        viewportType: tabletMode? "popup" : "float"
    }
}

