import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import globals 1.0

AbstractMain {
    id: app
    statusBarStyle: {
        if (mWin.viewport.currentType == "float" && !Devices.isAndroid)
            return AsemanApplication.StatusBarStyleLight;
        else
        if (mWin.viewport.currentType == "popup")
            return AsemanApplication.StatusBarStyleLight;
        else
        if (Colors.darkMode)
            return AsemanApplication.StatusBarStyleLight;
        else
        if (mWin.viewport.currentItem && mWin.viewport.currentItem.lightToolbar == true)
            return AsemanApplication.StatusBarStyleDark;
        else
            return (AsemanGlobals.introDone? AsemanApplication.StatusBarStyleLight : AsemanApplication.StatusBarStyleDark );
    }

    MainWindow {
        id: mWin
        visible: true
        font.family: Fonts.globalFont
    }

    Component.onCompleted: initialize()
}
