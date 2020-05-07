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

    signal clicked(string link)

    DelegateSwitch {
        id: dswitch

        Component {
            FlexiDynamicRow {
                width: rowItem.width
                listView: rowItem.listView
                model.data: modelData
                onClicked: rowItem.clicked(link)
            }
        }
        Component {
            id: staticComponent
            FlexiStaticRow {
                width: rowItem.width
                listView: rowItem.listView
                model.data: modelData
                onClicked: rowItem.clicked(link)
            }
        }
        Component {
            id: flexibleStaticComponent
            FlexiFlexibleRow {
                width: rowItem.width
                listView: rowItem.listView
                model.data: modelData
                onClicked: rowItem.clicked(link)
            }
        }
        Component {
            id: gridComponent
            FlexiGridRow {
                width: rowItem.width
                listView: rowItem.listView
                model.data: modelData
                onClicked: rowItem.clicked(link)
            }
        }
        Component {
            id: recentsComponent
            FlexiRecentRow {
                width: rowItem.width
                listView: rowItem.listView
                type: args.length? args * 1 : 3
                onClicked: rowItem.clicked(link)
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
            case "recents":
                return 4;
            default:
                return -1;
            }
        }
    }
}
