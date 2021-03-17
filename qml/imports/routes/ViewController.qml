pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import logics 1.0

ViewportController {
    id: viewController

    property int waitCount: 0
    property variant waitObj

    onWaitCountChanged: {
        if (waitCount > 0) {
            if (!waitObj) waitObj = trigger("dialog:/wait");
        } else {
            if (waitObj) waitObj.close()
        }
    }

    ViewportControllerRoute {
        route: /\w+\:\/account\/premium\/buy/
        source: "PremiumConfirmRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/settings/
        source: "SettingsRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/contactus/
        source: "ContactRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/changelogs/
        source: "ChangelogsRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/syncs/
        source: "SyncRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems/
        source: "MyBooksRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems\/add(?:\?.*bookId\=.+)?/
        source: "AddBookRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems(?:\?.*bookId\=.+)?/
        source: "MySubBooksRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poem\/random(?:\?.+)?/
        source: "PoemRoute.qml"
//        source: "RandomPoemRoute.qml"
//        viewportType: "none"
    }

    ViewportControllerRoute {
        route: /\w+\:\/web\?link=.+/
        source: "WebBrowserRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poet(?:\?.*catId\=.+)?/
        source: "PoetBooksRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poet(?:\?.*poemId\=.+)?/
        source: "PoemRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poet(?:\?.+)?/
        source: "PoetRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/search(?:\?.+)?/
        source: "SearchRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/search\/smart\-about(?:\?.+)?/
        source: "SearchSmartAboutRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poet\/bio(?:\?.+)?/
        source: "PoetBioRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poets(?:\?.+)?/
        source: "PoetsListRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/lists(?:\?.+)?/
        source: "ListsRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/lists\/add(?:\?.+)?/
        source: "AddListRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/lists\/delete(?:\?.+)?/
        source: "DeleteListRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/notes(?:\?.+)?/
        source: "NotesRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/notes\/add(?:\?.+)?/
        source: "AddNoteRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/offline\/manage/
        source: "ManageOfflinePoetsRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/favorites/
//        route: /\w+\:\/poets\/top/
        source: "TopPoetsRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/recents/
        source: "MostReadedPoemsRoute.qml"
        viewportType: "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/abouts/
        source: "AboutRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poem\/hafiz_faal/
        source: "HafizFaalRoute.qml"
        viewportType: "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/auth\/float/
        source: "AuthRoute.qml"
        viewportType: "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/auth\/changePassword(?:\?.+)?/
        source: "ChangePasswordRoute.qml"
        viewportType: "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/auth\/changeName(?:\?.+)?/
        source: "ChangeNameRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/sticker\/export/
        source: "StickerRoute.qml"
        viewportType: "float"
    }

    ViewportControllerRoute {
        route: /dialog:\/general\/error.*/
        source: "ErrorDialogRoute.qml"
    }

    ViewportControllerRoute {
        route: /dialog:\/wait/
        source: "WaitDialogRoute.qml"
    }
}

