import QtQuick 2.0
import AsemanTools 1.0
import Meikade 1.0
import AsemanTools.Awesome 1.0
import QtQuick.Layouts 1.3

Item {
    clip: true

    LayoutMirroring.enabled: false
    LayoutMirroring.childrenInherit: true

    property alias type: proxyModel.type

    XmlDownloaderProxyModel{
        id: proxyModel
        model: xml_model
    }

    AsemanListView {
        id: listv
        anchors.fill: parent
        model: proxyModel
        header: Item {
            width: listv.width
            height: title_txt.height + 4*Devices.density

            Text {
                id: title_txt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 8*Devices.density
                anchors.rightMargin: 8*Devices.density
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                font.family: AsemanApp.globalFont.family
                color: "#888888"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("Poets list, you can download from NileGroup servers...")
                visible: listv.count != 0
            }
        }

        delegate: Rectangle {
            width: listv.width
            height: 54*Devices.density
            color: marea.pressed? "#440d80ec" : "#00000000"

            PoetImageProvider {
                id: image_provider
                poet: model.poetId
            }

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 16*Devices.density
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10*Devices.density
                layoutDirection: View.layoutDirection

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.preferredHeight: 38*Devices.density
                    Layout.preferredWidth: Layout.preferredHeight

                    sourceSize: Qt.size(width,height)
                    fillMode: Image.PreserveAspectFit
                    source: image_provider.path
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    Layout.fillWidth: true

                    text: model.poetName
                    horizontalAlignment: View.defaultLayout? Text.AlignLeft : Text.AlignRight
                    font.pixelSize: 10*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 9*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: "#888888"
                    text: {
                        if(model.installing)
                            return qsTr("Installing")
                        else
                        if(model.downloadingState)
                            return qsTr("Downloading")
                        else
                        if(model.updateAvailable)
                            return qsTr("Update")
                        else
                        if(model.installed)
                            return qsTr("Installed")
                        else
                        if(model.downloadError)
                            return qsTr("Error")
                        else
                            return qsTr("Free")
                    }
                }

                Item {
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: Layout.preferredHeight

                    Text {
                        id: img
                        anchors.centerIn: parent
                        font.pixelSize: 15*globalFontDensity*Devices.fontDensity
                        font.family: Awesome.family
                        color: {
                            if(model.updateAvailable)
                                return "#0d80ec"
                            else
                            if(model.installed)
                                return "#3c994b"
                            else
                                return "#3d3d3d"
                        }
                        text: {
                            if(model.updateAvailable)
                                return Awesome.fa_download
                            else
                            if(model.installed)
                                return Awesome.fa_check_square_o
                            else
                                return Awesome.fa_plus
                        }
                        visible: !indicator.running
                    }

                    Indicator {
                        id: indicator
                        anchors.centerIn: parent
                        width: 18*Devices.density
                        height: width
                        light: false
                        modern: true
                        running: model.installing || model.downloadingState || model.downloadedStatus
                    }
                }
            }

            ProgressBar {
                width: parent.width
                height: 3*Devices.density
                anchors.bottom: parent.bottom
                visible: indicator.running
                percent: 100*model.downloadedBytes/model.fileSize
                transform: Scale { origin.x: width/2; origin.y: height/2; xScale: View.defaultLayout?1:-1}
                color: "#00000000"
            }

            Rectangle {
                width: parent.width
                height: 1*Devices.density
                color: "#e5e5e5"
                anchors.bottom: parent.bottom
            }

            MouseArea {
                id: marea
                anchors.fill: parent
                onClicked: {
                    if((!model.updateAvailable && model.installed) || indicator.running)
                        return

                    model.downloadingState = true
                    networkFeatures.pushAction( ("Poet Download: %1").arg(model.poetId) )
                }
            }
        }
    }

    ScrollBar {
        scrollArea: listv; height: listv.height; anchors.right: listv.right;
        anchors.top: listv.top; color: "#111111"
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }
}
