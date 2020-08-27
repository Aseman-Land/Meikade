import QtQuick 2.12
import views 1.0
import globals 1.0

SearchFilterView {
    width: Constants.width
    height: Constants.height

    onlineSearchSwitch.checked: AsemanGlobals.onlineSearch
    onlineSearchSwitch.onCheckedChanged: {
        if (initTimer.running)
            return;

        if (!onlineSearchSwitch.checked) {
            selectedListModel.clear()
        }
    }

    Timer {
        id: initTimer
        interval: 100
        running: true
        repeat: false
    }
}
