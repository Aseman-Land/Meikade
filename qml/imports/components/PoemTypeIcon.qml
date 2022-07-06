import QtQuick 2.0
import AsemanQml.Base 2.0

Item {
    id: scene
    implicitWidth: 48 * Devices.density
    implicitHeight: 48 * Devices.density

    property int type: PoemTypeIcon.TypeLeftRight
    property color color

    enum Type {
        TypeLeftRight = 0,
        TypeNormalText = 1,
        TypeLeftRight_LTR = 2,
        TypeNormalText_LTR = 3
    }

    Column {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width

        spacing: 3 * Devices.density
        Repeater {
            model: 4

            Rectangle {
                height: 3 * Devices.density
                color: scene.color
                radius: height / 2
                width: {
                    switch (type) {
                    case PoemTypeIcon.TypeLeftRight_LTR:
                    case PoemTypeIcon.TypeLeftRight:
                        return scene.width * 0.65;

                    case PoemTypeIcon.TypeNormalText_LTR:
                    case PoemTypeIcon.TypeNormalText:
                    default:
                        return scene.width * 0.7 + (model.index % 2 == 0? scene.width * 0.3 : 0);
                    }
                }
                x: {
                    switch (type) {
                    case PoemTypeIcon.TypeLeftRight:
                        return (model.index % 2 == 0? parent.width - width : 0);

                    case PoemTypeIcon.TypeLeftRight_LTR:
                        return (model.index % 2 == 0? 0 : parent.width - width);

                    case PoemTypeIcon.TypeNormalText_LTR:
                        return 0;

                    case PoemTypeIcon.TypeNormalText:
                    default:
                        return parent.width - width;
                    }
                }
            }
        }
    }
}
