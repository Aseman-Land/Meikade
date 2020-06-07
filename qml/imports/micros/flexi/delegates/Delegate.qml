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

    readonly property string displayTitle: GTranslations.translate(title) + Translations.refresher

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

//    ShadowRectangle {
//        anchors.fill: dswitch
//        anchors.margins: -30
//        shadowRadius: 32
//        shadowOpacity: 0.3
//        radius: Constants.radius
//        visible: dswitch.current == 0
//    }

    DelegateSwitch {
        id: dswitch
        anchors.fill: parent

        Component {
            NormalDelegate {
                anchors.fill: parent
                title.text: GTranslations.translate(delg.displayTitle)
                title.color: foregroundColor
                subtitle.text: GTranslations.translate(delg.subtitle)
                subtitle.color: foregroundColor
                image.source: delg.image.length? delg.image : Constants.thumbsBaseUrl + poetId + ".png"
                background.color: delg.color
                button.onClicked: delg.clicked()
            }
        }
        Component {
            FullBackgroundedDelegate {
                anchors.fill: parent
                title.text: GTranslations.translate(delg.displayTitle)
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
