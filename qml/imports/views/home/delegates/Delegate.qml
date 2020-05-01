import QtQuick 2.12
import AsemanQml.Base 2.0

Item {
    id: delg
    width: 400
    height: dswitch.height

    property string title
    property string description
    property string image
    property color color
    property string type
    property string link

    signal clicked()

    DelegateSwitch {
        id: dswitch

        Component {
            NormalDelegate {
                width: delg.width
                title.text: delg.title
                description.text: delg.description
                image.source: delg.image
                background.color: delg.color
                button.onClicked: delg.clicked()
            }
        }
        Component {
            FullBackgroundedDelegate {
                width: delg.width
                title.text: delg.title
                image.source: delg.image
                background.color: delg.color
                button.onClicked: delg.clicked()
            }
        }

        current: {
            switch (type) {
            case "normal":
                return 0;
            case "fullback":
                return 1;
            default:
                return -1;
            }
        }
    }
}
