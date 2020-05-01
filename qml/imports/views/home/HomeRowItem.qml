import QtQuick 2.12
import AsemanQml.Base 2.0

Item {
    id: rowItem
    width: 600
    height: dswitch.height

    property string type
    property variant modelData

    signal clicked(string link)

    DelegateSwitch {
        id: dswitch

        Component {
            HomeDynamicRow {
                width: rowItem.width
                model.data: modelData
                onClicked: rowItem.clicked(link)
            }
        }
        Component {
            id: staticComponent
            HomeStaticRow {
                width: rowItem.width
                model.data: modelData
                onClicked: rowItem.clicked(link)
            }
        }
        Component {
            id: flexibleStaticComponent
            HomeFlexibleRow {
                width: rowItem.width
                model.data: modelData
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
            default:
                return -1;
            }
        }
    }
}
