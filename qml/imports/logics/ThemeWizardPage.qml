import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import globals 1.0
import views 1.0

ThemeWizardView {
    id: dis
    Component.onCompleted: Tools.jsDelayCall(10, function(){ listView.currentIndex = 0 })

    closeBtn.onClicked: ViewportType.open = false
    applyBtn.onClicked: {
        var item = listView.model.get(listView.currentIndex);

        AsemanGlobals.mixedHeaderColor = !item.configColorToolbar;
        if (isAndroidStyle) {
            switch (item.configTheme) {
            case 0:
                AsemanGlobals.androidTheme = Material.System;
                break;
            case 1:
                AsemanGlobals.androidTheme = Material.Light;
                break;
            case 2:
                AsemanGlobals.androidTheme = Material.Dark;
                break;
            }
        } else {
            switch (item.configTheme) {
            case 0:
                AsemanGlobals.iosTheme = IOSStyle.System;
                break;
            case 1:
                AsemanGlobals.iosTheme = IOSStyle.Light;
                break;
            case 2:
                AsemanGlobals.iosTheme = IOSStyle.Dark;
                break;
            }
        }

        ViewportType.open = false
    }
}
