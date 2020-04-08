pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0

AsemanObject {
    id: viewController

    property alias viewport: viewport.viewport

    function trigger(url, properties) {
        viewport.trigger(url, properties)
    }

    ViewportController {
        id: viewport

        ViewportControllerRoute {
            route: /main:\/\/test\/.*/
            component: "hiComponent"
            viewportType: "popup"
        }

        ViewportControllerRoute {
            route: /popup\:\/search\/domains/
            component: domainComponent
            viewportType: "popup"
        }
    }

    Component {
        id: domainComponent
        Rectangle {
        }
    }
}
