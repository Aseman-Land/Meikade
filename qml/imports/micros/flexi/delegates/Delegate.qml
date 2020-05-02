import QtQuick 2.12
import AsemanQml.Base 2.0

Item {
    id: delg

    property string title
    property string subtitle
    property string image
    property color color
    property string type
    property string link

    readonly property color foregroundColor: (color.r + color.g + color.b) / 3 < 0.5? "#fff" : "#333"

    signal clicked()

    DelegateSwitch {
        id: dswitch
        anchors.fill: parent

        Component {
            NormalDelegate {
                anchors.fill: parent
                title.text: delg.title
                title.color: foregroundColor
                subtitle.text: delg.subtitle
                image.source: delg.image
                background.color: delg.color
                button.onClicked: delg.clicked()
            }
        }
        Component {
            FullBackgroundedDelegate {
                anchors.fill: parent
                title.text: delg.title
                title.color: foregroundColor
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
