import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import globals 1.0

AbstractMain {
    id: app
    statusBarStyle: {
        if (AsemanGlobals.introDone)
            return AsemanApplication.StatusBarStyleLight;

        if (mWin.viewport.currentType == "float" && !Devices.isAndroid)
            return AsemanApplication.StatusBarStyleLight;
        else
        if (Colors.darkMode)
            return AsemanApplication.StatusBarStyleLight;
        else
            return AsemanApplication.StatusBarStyleDark;
    }

    MainWindow {
        id: mWin
        visible: true
        font.family: Fonts.globalFont
    }

    Component.onCompleted: initialize()
}
