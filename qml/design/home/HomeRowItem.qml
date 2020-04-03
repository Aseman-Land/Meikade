import QtQuick 2.12
import AsemanQml.Base 2.0

Item {
    id: rowItem
    width: 600
    height: dswitch.height

    property string type
    property variant modelData

    DelegateSwitch {
        id: dswitch

        Component {
            HomeRecentRow {
                width: rowItem.width
                model.data: modelData
            }
        }
        Component {
            id: staticComponent
            HomeStaticRow {
                width: rowItem.width
                model.data: modelData
            }
        }

        current: {
            switch (type) {
            case "recents":
                return 0;
            case "static":
                return 1;
            default:
                return -1;
            }
        }
    }
}
