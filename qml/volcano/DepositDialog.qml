import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0
import AsemanQml.Viewport 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.IOSStyle 2.0
import components 1.0
import requests 1.0
import globals 1.0

NullMouseArea {
    id: dis
    width: Viewport.viewport.width
    height: (resultColumn.visible? resultColumn.height : generateColumn.height) + headerItem.height + Devices.navigationBarHeight

    Behavior on height {
        NumberAnimation { easing.type: Easing.OutCubic; duration: 250 }
    }

    property alias headerLabel: headerLabel
    property alias headerItem: headerItem

    Rectangle {
        anchors.fill: parent
        color: Colors.background
        opacity: 0.5
    }

    SubmitVolcanoDepositRequest {
        id: depositReq
        onSuccessfull: {
            try {
                if (qzxing) {
                    qrImage.source = "image://QZXing/encode/" + response.result.payment_req;
                }
                paymentLink.text = response.result.payment_req;
                resultColumn.visible = true;
            } catch (e) {
                qrImage.source = "";
                paymentLink.text = "";
                resultColumn.visible = false;
            }
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        visible: depositReq.refreshing

        BusyIndicator {
            Layout.alignment: Qt.AlignHCenter
            running: depositReq.refreshing
        }

        Label {
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Generating Deposit...") + Translations.refresher
        }
    }

    ColumnLayout {
        id: resultColumn
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        spacing: 4 * Devices.density
        visible: false;

        Label {
            id: bodyLabel
            Layout.fillWidth: true
            Layout.topMargin: 10 * Devices.density
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 9 * Devices.fontDensity
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            color: Colors.accent
            text: qsTr("Copy code or Scan below QR using a lightning wallet (like BlueWallet) to complete deposit.") + Translations.refresher
        }

        Image {
            id: qrImage
            Layout.topMargin: 40 * Devices.density
            Layout.bottomMargin: 40 * Devices.density
            Layout.preferredWidth: dis.width - 80 * Devices.density
            Layout.preferredHeight: dis.width - 80 * Devices.density
            Layout.alignment: Qt.AlignHCenter
            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size(width, height)
            asynchronous: true
            mipmap: true
        }

        ItemDelegate {
            Layout.fillWidth: true
            Layout.preferredHeight: 50 * Devices.density
            Layout.bottomMargin: Devices.navigationBarHeight
            onClicked: {
                Devices.clipboard = paymentLink.text;
                GlobalSignals.snackRequest(qsTr("Payment key copied to the clipboard."));
            }

            RowLayout {
                spacing: 10 * Devices.density
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20 * Devices.density

                Label {
                    font.pixelSize: 9 * Devices.fontDensity
                    text: qsTr("Click to copy:")
                    font.bold: true
                    color: Colors.accent
                }

                Label {
                    id: paymentLink
                    Layout.fillWidth: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: 9 * Devices.fontDensity
                    maximumLineCount: 1
                    elide: Text.ElideRight
                }
            }
        }
    }

    ColumnLayout {
        id: generateColumn
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        spacing: 4 * Devices.density
        visible: !depositReq.refreshing && !resultColumn.visible

        Label {
            Layout.fillWidth: true
            Layout.topMargin: 10 * Devices.density
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            horizontalAlignment: Text.AlignLeft
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            color: Colors.accent
            text: qsTr("Please enter value you want to deposit to your account:") + Translations.refresher
        }

        PriceField {
            id: priceField
            Layout.fillWidth: true
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            unit.text: qsTr("Satoshi") + Translations.refresher
            onTextChanged: {
                if (signalBlocker)
                    return;

                signalBlocker = true;
                var val = getValue();
                if (val > Bootstrap.tips.max_account_deposit / 1000)
                    val = Bootstrap.tips.max_account_deposit / 1000;
                if (val < Bootstrap.tips.min_account_deposit / 1000)
                    val = Bootstrap.tips.min_account_deposit / 1000;

                Tools.jsDelayCall(1, function(){
                    setValue(Math.floor(val));
                    signalBlocker = false;
                })
            }
            Component.onCompleted: setValue(Math.floor(Bootstrap.tips.min_account_deposit / 1000))

            property bool signalBlocker: false
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            spacing: 4 * Devices.density

            Label {
                horizontalAlignment: Text.AlignLeft
                font.bold: true
                color: Colors.accent
                font.pixelSize: 7 * Devices.fontDensity
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("Minimum:") + Translations.refresher
            }

            Label {
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: 7 * Devices.fontDensity
                text: qsTr("%1 satoshi,").arg(Math.floor(Bootstrap.tips.min_account_deposit / 1000))
            }

            Label {
                horizontalAlignment: Text.AlignLeft
                font.bold: true
                color: Colors.accent
                font.pixelSize: 7 * Devices.fontDensity
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: qsTr("Maxmium:") + Translations.refresher
            }

            Label {
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: 7 * Devices.fontDensity
                text: qsTr("%1 satoshi").arg(Math.floor(Bootstrap.tips.max_account_deposit / 1000))
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 1 * Devices.density
            }
        }

        Button {
            id: rejectBtn
            Layout.fillWidth: true
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Cancel") + Translations.refresher
            onClicked: {
                dis.ViewportType.open = false;
            }
        }

        Button {
            id: confirmBtn
            Layout.fillWidth: true
            Layout.leftMargin: 20 * Devices.density
            Layout.rightMargin: 20 * Devices.density
            Layout.bottomMargin: 20 * Devices.density
            text: qsTr("Generate payment key") + Translations.refresher
            font.pixelSize: 9 * Devices.fontDensity
            highlighted: true
            onClicked: {
                depositReq.amount_msat = priceField.getValue() * 1000;
                depositReq.doRequest();
            }
        }
    }

    Item {
        id: headerItem
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: Devices.standardTitleBarHeight

        Separator {}

        Label {
            id: headerLabel
            anchors.centerIn: parent
            font.pixelSize: 9 * Devices.fontDensity
            text: qsTr("Deposit") + Translations.refresher
        }
    }

    HeaderBackButton {
        ratio: 1
        y: headerItem.height/2 - height/2
        onClicked: dis.ViewportType.open = false
        property bool isIOSPopup: true
    }
}
