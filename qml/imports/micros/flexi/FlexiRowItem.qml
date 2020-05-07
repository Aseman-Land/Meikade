import QtQuick 2.12
import AsemanQml.Base 2.0

Item {
    id: rowItem
    width: 600
    height: dswitch.height

    property string type
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
                onClicked: rowItem.clicked(link)
            }
        }

        current: {
            switch (type) {
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
