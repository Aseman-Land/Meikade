pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import logics 1.0

AsemanObject {
    id: viewController

    property alias viewport: viewport.viewport

    function trigger(url, properties) {
        viewport.trigger(url, properties)
    }

    ViewportController {
        id: viewport

        ViewportControllerRoute {
            route: /popup\:\/search\/domains/
            sourceComponent: domainComponent
            viewportType: "ios-popup"
        }

        ViewportControllerRoute {
            route: /popup\:\/auth\/float/
            sourceComponent: authFloatComponent
            viewportType: "ios-popup"
        }
    }

    Component {
        id: domainComponent
        Rectangle {
        }
    }
    Component {
        id: authFloatComponent
        AuthPage {
            anchors.fill: parent
            viewport: viewController.viewport
        }
    }
}
