import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import AsemanQml.Controls 2.0
import AsemanQml.GraphicalEffects 2.0
import QZXing 3.3
import components 1.0

MPage {
    id: dis

    signal tagFound(string tag)
    
    Camera {
        id: camera
        focus.focusMode: Camera.FocusContinuous
        captureMode: Camera.CaptureViewfinder
        viewfinder.resolution: {
            var list = imageCapture.supportedResolutions
            for(var i in list) {
                var sz = list[i]
                if(sz.width >= 800)
                    return sz
            }

            var idx = Math.floor(list.length/2)
            if(list.length >= idx)
                return Qt.size(0, 0)
            return list[idx]
        }
    }

    QZXingFilter {
        id: zxingFilter
        captureRect: cameraOutput.sourceRect
        decoder {
            enabledDecoders: QZXing.DecoderFormat_QR_CODE
            onTagFound: {
                dis.tagFound(tag);
                dis.ViewportType.open = false;
            }
            tryHarder: true
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent

        Item {
            id: cameraFrame
            Layout.bottomMargin: 10 * Devices.density
            Layout.fillHeight: true
            Layout.fillWidth: true

            VideoOutput {
                id: cameraOutput
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectCrop
                autoOrientation: true
                source: camera
                filters: [ zxingFilter ]
            }

            Rectangle {
                id: focusBorder
                width: parent.width * 0.6
                height: width
                color: "#00000000"
                radius: 12 * Devices.density
                border.width: 1 * Devices.density
                border.color: Material.accent
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Item {
                    id: focusEffectBorder
                    anchors.fill: parent
                    visible: false

                    Rectangle {
                        id: focusInnerBorder
                        color: "#00000000"
                        radius: 12 * Devices.density
                        anchors.fill: parent
                        anchors.margins: 40 * Devices.density
                        border.color: Material.accent
                        border.width: 1 * Devices.density
                    }
                }

                Item {
                    id: focusMaskBorder
                    anchors.fill: parent
                    visible: false

                    Rectangle {
                        width: parent.width * 0.35
                        height: width
                        color: "#ffffff"
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                    }

                    Rectangle {
                        width: parent.width * 0.35
                        height: width
                        color: "#ffffff"
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                    }

                    Rectangle {
                        width: parent.width * 0.35
                        height: width
                        color: "#ffffff"
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.topMargin: 0
                    }

                    Rectangle {
                        width: parent.width * 0.35
                        height: 96
                        color: "#ffffff"
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                    }
                }

                OpacityMask {
                    anchors.fill: parent
                    source: focusEffectBorder
                    maskSource: focusMaskBorder
                }

                MLabel {
                    id: cameraLoading
                    text: qsTr("Please wait") + Translations.refresher
                    font.capitalization: Font.AllUppercase
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Material.accent
                    visible: camera.cameraStatus != Camera.ActiveStatus
                }
            }
        }

        MButton {
            id: cancelBtn
            text: qsTr("Cancel") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
            Layout.bottomMargin: 20 * Devices.density
            highlighted: true
            Layout.rightMargin: 20 * Devices.density
            Layout.leftMargin: 20 * Devices.density
            Layout.fillWidth: true
            onClicked: dis.ViewportType.open = false
        }
    }
}
