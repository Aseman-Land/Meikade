import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import globals 1.0
import queries 1.0
import requests 1.0

AsemanApplication {
    id: app
    applicationName: "Meikade"
    applicationAbout: "Meikade"
    applicationDisplayName: "Meikade"
    applicationId: "0e3103ed-dfb2-49df-95d2-3bcbec76fa34"
    applicationVersion: appVersion
    organizationDomain: "meikade.com"
    statusBarStyle: AsemanApplication.StatusBarStyleLight;

    property bool initialized: false

    function initialize() {
        GTranslations.init();
        Fonts.init();
        UserDbUpdater.init();
        DataDbUpdater.init();
        MyUserRequest.init();
        StoreActionsBulk.init();
        ActivityManager.reload();

        if (Devices.isDesktop) Devices.fontScale = 1.1;
        if (Devices.isMacX) Devices.fontScale = 1.2;
        if (Devices.isAndroid) Devices.fontScale = 0.92;
        if (Devices.isIOS) Devices.fontScale = 1.1;

        initialized = true;
    }

    onApplicationStateChanged: {
        if (!initialized)
            return;

        switch (applicationState) {
        case 4:
            StoreActionsBulk.syncActionsInterval();
            MyUserRequest.refresh();
            break;
        }
    }
}
