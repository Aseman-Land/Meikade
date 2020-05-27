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
        if (waitCount) {
            if (!waitObj) waitObj = trigger("dialog:/wait");
        } else {
            if (waitObj) waitObj.close()
        }
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
        route: /\w+\:\/poet\/bio(?:\?.+)?/
        source: "PoetBioRoute.qml"
    }

    ViewportControllerRoute {
        route: /\w+\:\/poets(?:\?.+)?/
        source: "PoetsListRoute.qml"
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
        route: /dialog:\/general\/error.*/
        source: "ErrorDialogRoute.qml"
    }

    ViewportControllerRoute {
        route: /dialog:\/wait/
        source: "WaitDialogRoute.qml"
    }
}

