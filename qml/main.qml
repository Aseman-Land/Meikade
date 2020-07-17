import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import globals 1.0
import queries 1.0
import requests 1.0

AsemanApplication {
    id: app
    applicationAbout: "Meikade"
    applicationDisplayName: "Meikade"
    applicationId: "0e3103ed-dfb2-49df-95d2-3bcbec76fa34"
    applicationVersion: appVersion
    organizationDomain: "meikade.com"
    statusBarStyle: {
        if (AsemanGlobals.introDone)
            return AsemanApplication.StatusBarStyleLight;
        if (Colors.darkMode)
            return AsemanApplication.StatusBarStyleLight;
        else
            return AsemanApplication.StatusBarStyleDark;
    }
    Component.onCompleted: {
        GTranslations.init();
        Fonts.init();
        UserDbUpdater.init();
        DataDbUpdater.init();
        MyUserRequest.init();
        StoreActionsBulk.init();

        if (Devices.isDesktop) Devices.fontScale = 1.1;
        if (Devices.isMacX) Devices.fontScale = 1.2;
        if (Devices.isAndroid) Devices.fontScale = 0.92;
        if (Devices.isIOS) Devices.fontScale = 1.1;
    }

    onApplicationStateChanged: if (applicationState == 4) StoreActionsBulk.syncActionsInterval()

    MainWindow {
        visible: true
        font.family: Fonts.globalFont
    }
}
