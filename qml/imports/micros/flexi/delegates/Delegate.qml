import QtQuick 2.12
import AsemanQml.Base 2.0
import globals 1.0

Item {
    id: delg

    property string title
    property string subtitle
    property string image
    property color color
    property string type
    property string link
    property bool isVerse
    property bool moreHint

    readonly property int poetId: {
        var ids = Tools.stringRegExp(link, "id\\=(\\d+)", false)
        if (!ids || ids.length === 0)
            return "";

        return ids[0][1]
    }

    readonly property color foregroundColor: (color.r + color.g + color.b) / 3 < 0.5? "#fff" : "#333"

    signal clicked()
    signal moreRequest()

    Component.onCompleted: if (moreHint) moreRequest();

    DelegateSwitch {
        id: dswitch
        anchors.fill: parent

        Component {
            NormalDelegate {
                anchors.fill: parent
                title.text: Tools.stringReplace(delg.title, "\\s+", " ", true)
                title.color: foregroundColor
                subtitle.text: Tools.stringReplace(delg.subtitle, "\\s+", " ", true)
                subtitle.color: foregroundColor
                image.source: delg.image.length? delg.image : Constants.thumbsBaseUrl + poetId + ".png"
                background.color: delg.color
                button.onClicked: delg.clicked()
            }
        }
        Component {
            FullBackgroundedDelegate {
                anchors.fill: parent
                title.text: Tools.stringReplace(delg.title, "\\s+", " ", true)
                title.color: foregroundColor
                image.source: delg.image
                background.color: delg.color
                button.onClicked: delg.clicked()
                Component.onCompleted: {
                    if (!isVerse) {
                        title.horizontalAlignment = Text.AlignHCenter;
                    }
                }
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
