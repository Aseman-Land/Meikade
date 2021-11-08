import QtQuick 2.12
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0

PublishView {
    id: publishPage
    width: Constants.width
    height: Constants.height

    closeBtn.onClicked: ViewportType.open = false

    Behavior on initedNum {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 350 }
    }
    Behavior on agreementNum {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 350 }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            interval = 400
            if (publishPage.initedNum == 0)
                publishPage.initedNum = 1;
            else
            if (publishPage.agreementNum == 0)
                publishPage.agreementNum = 1;
            else
                stop();
        }
    }
}

