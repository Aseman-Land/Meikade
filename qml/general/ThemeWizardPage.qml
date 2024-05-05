import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import globals 1.0
import "views"

ThemeWizardView {
    id: dis
    Component.onCompleted: Tools.jsDelayCall(10, function(){ listView.currentIndex = 0 })

    closeBtn.onClicked: ViewportType.open = false
    applyBtn.onClicked: {
        var item = listView.model.get(listView.currentIndex);

        AsemanGlobals.mixedHeaderColor = !item.configColorToolbar;
        AsemanGlobals.androidTheme = item.configTheme;
        AsemanGlobals.iosTheme = item.configTheme;
        ViewportType.open = false
    }
}


