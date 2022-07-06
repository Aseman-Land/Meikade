import QtQuick 2.12
import AsemanQml.Viewport 2.0
import globals 1.0
import "views"

SearchFilterView {
    width: Constants.width
    height: Constants.height

    property bool accurateSearch: !AsemanGlobals.smartSearch

    accurateSearchHelpBtn.onClicked: Viewport.controller.trigger("bottomdrawer:/search/smart-about")

    accurateSearchSwitch.checked: accurateSearch
    accurateSearchSwitch.onCheckedChanged: {
        if (initTimer.running)
            return;
        if (onlineSearchSwitch.checked)
            accurateSearch = accurateSearchSwitch.checked;
    }

    onlineSearchSwitch.checked: AsemanGlobals.onlineSearch
    onlineSearchSwitch.onCheckedChanged: {
        if (initTimer.running)
            return;

        if (!onlineSearchSwitch.checked) {
            selectedListModel.clear()
            accurateSearchSwitch.checked = true;
        } else {
            accurateSearchSwitch.checked = accurateSearch;
        }
    }

    Timer {
        id: initTimer
        interval: 100
        running: true
        repeat: false
    }
}


