import QtQuick 2.0
import AsemanTools 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0

Popup {
    id: popup
    x: parent.width/2 - width/2
    y: parent.height/2 - height/2
    modal: true
    focus: true

    onVisibleChanged: {
        if(visible) {
            BackHandler.pushHandler(popup, function(){popup.visible = false})
        } else {
            BackHandler.removeHandler(popup)
            Tools.jsDelayCall(500, function(){popup.destroy()})
        }
    }

    contentItem:  ColumnLayout {
        id: column

        Label {
            color: "#333333"
            font.pixelSize: 20*Devices.density
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Language"
        }

        AsemanListView {
            id: listViewTumbler
            height: 200*Devices.density
            Layout.minimumWidth: 200*Devices.density
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.horizontalCenter: parent.horizontalCenter
            model: [ "English", "فارسی" ]
            onCurrentIndexChanged: {
                switch(listViewTumbler.currentIndex)
                {
                case 0:
                    Meikade.currentLanguage = "English"
                    break
                case 1:
                    Meikade.currentLanguage = "Persian"
                    break
                }
            }

            delegate: RadioButton {
                text: model.text
                checked: listViewTumbler.currentIndex == index
                onCheckedChanged: if(checked) listViewTumbler.currentIndex = index
            }
        }

        Button {
            id: okButton
            text: "Ok"
            onClicked: popup.close()

            Material.foreground: Material.LightBlue
            Material.background: "transparent"
            Material.elevation: 0

            Layout.preferredWidth: 0
            Layout.fillWidth: true
        }

        Component.onCompleted: {
            if(Meikade.currentLanguage == "Persian")
                listViewTumbler.currentIndex = 1
            else
                listViewTumbler.currentIndex = 0
        }
    }
}

