import QtQuick 2.12
import AsemanQml.Base 2.0
import Meikade 1.0
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

    Loader {
        id: dswitchLoader
        asynchronous: Devices.isAndroid
        anchors.fill: parent
        sourceComponent: DelegateSwitch {
            id: dswitch
            anchors.fill: parent

            Component {
                NormalDelegate {
                    id: norm_del
                    anchors.fill: parent
                    title.text: GTranslations.translate(delg.displayTitle)
                    title.color: analizer.textColor
                    subtitle.text: GTranslations.translate(delg.subtitle)
                    subtitle.color: analizer.textColor
                    cachedImage.source: AsemanGlobals.testPoetImagesDisable? "" : (delg.image.length? delg.image : Constants.thumbsBaseUrl + poetId + ".png")
                    image.source: analizer_small.imageResult
                    background.color: Colors.darkMode? Qt.darker(analizer.color, 1.5) : analizer.color
                    blurImage.source: analizer.imageResult
                    button.onClicked: delg.clicked()

                    property color titleColor: {
                        if (delg.color != "#ffffff" || delg.link.indexOf(":/poet?id=") == -1)
                            return delg.color;
                        if (delg.subtitle.length == 0)
                            return delg.color;

                        var md5 = Tools.md5(delg.subtitle);
                        var colors = new Array;
                        for (var i = 0; i < md5.length; i++) {
                            var clr = Math.floor(i / 10);
                            var code = parseInt(md5[i], 36) + 1;
                            if (clr < colors.length)
                                colors[clr] = code * colors[clr];
                            else
                                colors[clr] = code;
                        }

                        return Qt.hsla((colors[0] % 255) / 255,
                                       (20 + (colors[1] % 55)) / 255,
                                       (100 + (colors[1] % 55)) / 255,
                                       1);
                    }

                    DelegateDataAnalizer {
                        id: analizer
                        source: norm_del.cachedImage.cachedSource
                        colorAnalizer: true
                        defaultColor: norm_del.titleColor
//                        blur: 32
//                        size: Qt.size(norm_del.height, norm_del.height)
//                        radius: norm_del.radius
                        cachePath: AsemanGlobals.cachePath
                    }

                    DelegateDataAnalizer {
                        id: analizer_small
                        source: norm_del.cachedImage.cachedSource
                        size: Qt.size(norm_del.image.height, norm_del.image.height)
                        radius: norm_del.radius / 2
                        cachePath: AsemanGlobals.cachePath
                    }
                }
            }
            Component {
                FullBackgroundedDelegate {
                    id: full_del
                    anchors.fill: parent
                    title.text: GTranslations.translate(delg.displayTitle)
                    title.color: foregroundColor
                    cachedImage.source: delg.image
                    image.source: analizer.imageResult
                    background.color: delg.color
                    button.onClicked: delg.clicked()
                    Component.onCompleted: {
                        if (!isVerse) {
                            title.horizontalAlignment = Text.AlignHCenter;
                        }
                    }

                    DelegateDataAnalizer {
                        id: analizer
                        source: full_del.cachedImage.cachedSource
                        size: Qt.size(full_del.image.height, full_del.image.height)
                        radius: full_del.radius
                        cachePath: AsemanGlobals.cachePath
                    }
                }
            }

            current: {
                switch (type.toLowerCase()) {
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

}
