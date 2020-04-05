pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0

ViewportController {
    id: viewController

    ViewportControllerRoute {
        route: /main:\/\/test\/.*/
        component: "hiComponent"
        viewportType: "popup"
    }

    ViewportControllerRoute {
        route: /about:\/\/aseman\/.*/
        component: "aboutComponent"
        viewportType: "page"
    }
}
