import QtQuick 2.12
import AsemanQml.Base 2.0

Item {
    id: rowItem
    width: 600
    height: dswitch.height

    property string type
    readonly property string args: {
        var idx = type.indexOf(":");
        if (idx < 0)
            return "";

        return t.slice(idx+1);
    }

    property variant modelData
    property ListView listView

    signal clicked(string link, variant properties)

    DelegateSwitch {
        id: dswitch

        Component {
            FlexiDynamicRow {
                width: rowItem.width
                listView: rowItem.listView
                model.data: modelData
                onClicked: rowItem.clicked(link, properties)
            }
        }
        Component {
            id: staticComponent
            FlexiStaticRow {
                width: rowItem.width
                listView: rowItem.listView
                model.data: modelData
                onClicked: rowItem.clicked(link, properties)
            }
        }
        Component {
            id: flexibleStaticComponent
            FlexiFlexibleRow {
                width: rowItem.width
                listView: rowItem.listView
                model.data: modelData
                onClicked: rowItem.clicked(link, properties)
            }
        }
        Component {
            id: gridComponent
            FlexiGridRow {
                width: rowItem.width
                listView: rowItem.listView
                model.data: modelData
                onClicked: rowItem.clicked(link, properties)
            }
        }
        Component {
            id: columnComponent
            FlexiColumnRow {
                width: rowItem.width
                listView: rowItem.listView
                model.data: modelData
                onClicked: rowItem.clicked(link, properties)
            }
        }
        Component {
            id: recentsComponent
            FlexiRecentRow {
                width: rowItem.width
                listView: rowItem.listView
                type: args.length? args * 1 : 5
                onClicked: rowItem.clicked(link, properties)
            }
        }

        current: {
            var t = type
            var idx = type.indexOf(":");
            if (idx >= 0)
                t = t.slice(0, idx)

            switch (t) {
            case "dynamic":
                return 0;
            case "static":
                return 1;
            case "flexible":
                return 2;
            case "grid":
                return 3;
            case "column":
                return 4;
            case "recents":
                return 5;
            default:
                return -1;
            }
        }
    }
}
