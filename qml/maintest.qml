import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import globals 1.0
import logics 1.0

AbstractMain {
    id: app

    function start() {
        initialize();
        mWin.mainLoader.active = true;
    }

    MainWindow {
        id: mWin
        visible: true
        font.family: Fonts.globalFont

        TestDialog {
            anchors.fill: parent
            onLoadRequest: {
                visible = false;
                app.start();
            }
        }
    }
}
