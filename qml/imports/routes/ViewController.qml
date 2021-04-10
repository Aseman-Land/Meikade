pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import logics 1.0

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
        source: "PremiumConfirmRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/settings/
        source: "SettingsRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/settings\/theme/
        source: "ThemeWizardRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/contactus/
        source: "ContactRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/changelogs/
        source: "ChangelogsRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/syncs/
        source: "SyncRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems/
        source: "MyBooksRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems\/add(?:\?.*bookId\=.+)?/
        source: "AddBookRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems\/poem\/add(?:\?.*bookId\=.+)?/
        source: "AddPoemRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems\/poem\/edit(?:\?.*bookId\=.+)?/
        source: "EditPoemRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems(?:\?.*bookId\=.+)?/
        source: "MySubBooksRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/mypoems\/poem(?:\?.*poemId\=.+)?/
        source: "MyPoemRoute.qml"
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
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/poet(?:\?.*poemId\=.+)?/
        source: "PoemRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poet(?:\?.+)?/
        source: "PoetRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/search(?:\?.+)?/
        source: "SearchRoute.qml"
        viewportType: tabletMode? "popup" : ""
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
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/lists(?:\?.+)?/
        source: "ListsRoute.qml"
        viewportType: tabletMode? "popup" : ""
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
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/notes\/add(?:\?.+)?/
        source: "AddNoteRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/offline\/manage/
        source: "ManageOfflinePoetsRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/favorites/
//        route: /\w+\:\/poets\/top/
        source: "TopPoetsRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/recents/
        source: "MostReadedPoemsRoute.qml"
        viewportType: tabletMode? "popup" : "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/abouts/
        source: "AboutRoute.qml"
        viewportType: tabletMode? "popup" : ""
    }

    ViewportControllerRoute {
        route: /\w+\:\/poem\/hafiz_faal/
        source: "HafizFaalRoute.qml"
        viewportType: tabletMode? "popup" : "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/auth\/float/
        source: "AuthRoute.qml"
        viewportType: tabletMode? "popup" : "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/auth\/changePassword(?:\?.+)?/
        source: "ChangePasswordRoute.qml"
        viewportType: tabletMode? "popup" : "float"
    }

    ViewportControllerRoute {
        route: /\w+\:\/auth\/changeName(?:\?.+)?/
        source: "ChangeNameRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/sticker\/export/
        source: "StickerRoute.qml"
        viewportType: tabletMode? "popup" : "float"
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

