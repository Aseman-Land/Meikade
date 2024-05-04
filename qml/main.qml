import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Controls.Beta 3.0
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

    Style.globalFontFamilies: Fonts.globalFont
    Style.globalFontPixelSize: 9 * Devices.fontDensity
    Style.stylesSearchPath: [":/AsemanQml/Controls/Beta/styles/"]
    Style.styleName: "simple"
    Style.primaryColor: Colors.headerColor
    Style.primaryTextColor: Colors.foreground
    Style.accentColor: Colors.accent
    Style.accentTextColor: "#fff"
    Style.foregroundColor: Colors.foreground
    Style.backgroundColor: Colors.background
    Style.baseColor: Colors.background
    Style.baseTextColor: Colors.foreground

    MainWindow {
        id: mWin
        visible: true
    }

    Component.onCompleted: initialize()
}
