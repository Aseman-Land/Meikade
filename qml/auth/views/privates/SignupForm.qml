import QtQuick 2.14
import globals 1.0
import components 1.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Controls.Beta 3.0
import AsemanQml.Controls 2.0

MPage {
    id: page
    width: Constants.width
    height: Constants.height

    readonly property bool lightToolbar: Colors.lightHeader

    property alias headerItem: headerItem
    property alias scene: scene

    property alias cancelBtn: cancelBtn
    property alias loginLabel: loginLabel
    property alias userTxt: userTxt
    property alias passTxt: passTxt
    property alias fullnameTxt: fullnameTxt
    property alias emailTxt: emailTxt
    property alias sendBtn: sendBtn
    property alias usernameError: usernameError
    property alias backgroudMouseArea: backgroudMouseArea
    property alias userCheckIndicator: userCheckIndicator

    AsemanFlickable {
        id: flickable
        anchors.fill: parent
        contentWidth: scene.width
        contentHeight: scene.height

        Item {
            id: scene
            width: flickable.width
            height: flickable.height

            MouseArea {
                id: backgroudMouseArea
                anchors.fill: parent
            }

            Column {
                id: columnLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 20 * Devices.density
                spacing: 8 * Devices.density

                MLabel {
                    id: loginLabel
                    text: qsTr("Fill below form with your details below to signing up.") + Translations.refresher
                    width: parent.width
                    wrapMode: Text.WordWrap
                }

                MTextField {
                    id: userTxt
                    width: parent.width
                    placeholderText: qsTr("Username") + '*' + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignHCenter
                    inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                    selectByMouse: true
                    leftPadding: LayoutMirroring.enabled? 0 : 34 * Devices.density
                    rightPadding: LayoutMirroring.enabled? 34 * Devices.density : 0
                    validator: RegularExpressionValidator { regularExpression: /[a-z][a-z0-9_]+/ }
                    onAccepted: passTxt.focus = true
                    color: focus || userCheckIndicator.running? Colors.foreground : (usernameError.visible || !isValid? "#a00" : "#0a0")

                    property bool isValid: acceptableInput && length > 5

                    MLabel {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        anchors.margins: 8 * Devices.density
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_account
                        color: Colors.accent
                    }

                    BusyIndicator {
                        id: userCheckIndicator
                        scale: Devices.isAndroid? 0.4 : 0.6
                        anchors.right: parent.right
                        anchors.rightMargin: 8 * Devices.density
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        running: false
                    }
                }

                MTextField {
                    id: passTxt
                    width: parent.width
                    placeholderText: qsTr("Password") + '*' + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignHCenter
                    leftPadding: LayoutMirroring.enabled? 0 : 34 * Devices.density
                    rightPadding: LayoutMirroring.enabled? 34 * Devices.density : 0
                    selectByMouse: true
                    echoMode: TextInput.Password
                    passwordCharacter: '*'
                    passwordMaskDelay: 500
                    validator: RegularExpressionValidator { regularExpression: /\w*[0-9\+_\)\(\*\&\^\%\$\#\@\!\[\]\{\}\:\;\"\'\\\.\,\`\/\<\>\|]+\w*/ }
                    onAccepted: fullnameTxt.focus = true
                    color: isValid || focus? Colors.foreground : "#a00"

                    property bool isValid: acceptableInput && length > 7

                    MLabel {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        anchors.margins: 8 * Devices.density
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_lock
                        color: Colors.accent
                    }
                }

                MTextField {
                    id: fullnameTxt
                    width: parent.width
                    placeholderText: qsTr("Full Name") + '*' + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    leftPadding: LayoutMirroring.enabled? 0 : 34 * Devices.density
                    rightPadding: LayoutMirroring.enabled? 34 * Devices.density : 0
                    validator: RegularExpressionValidator { regularExpression: /[\w\s]+/ }
                    onAccepted: emailTxt.focus = true
                    color: isValid || focus? Colors.foreground : "#a00"

                    property bool isValid: length > 5

                    MLabel {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        anchors.margins: 8 * Devices.density
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_pencil
                        color: Colors.accent
                    }
                }

                MTextField {
                    id: emailTxt
                    width: parent.width
                    placeholderText: qsTr("Email") + Translations.refresher
                    font.pixelSize: 9 * Devices.fontDensity
                    horizontalAlignment: Text.AlignHCenter
                    selectByMouse: true
                    leftPadding: LayoutMirroring.enabled? 0 : 34 * Devices.density
                    rightPadding: LayoutMirroring.enabled? 34 * Devices.density : 0
                    validator: RegularExpressionValidator { regularExpression: /\w(\w|\.)+\@\w+(\.\w+)+/ }
                    onAccepted: sendBtn.focus = true
                    color: isValid || focus? Colors.foreground : "#a00"

                    property bool isValid: acceptableInput || length == 0

                    MLabel {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 4 * Devices.density
                        anchors.margins: 8 * Devices.density
                        font.pixelSize: 12 * Devices.fontDensity
                        font.family: MaterialIcons.family
                        text: MaterialIcons.mdi_email
                        color: Colors.accent
                    }
                }

                MButton {
                    id: sendBtn
                    text: qsTr("Sign Up") + Translations.refresher
                    width: parent.width
                    font.pixelSize: 9 * Devices.fontDensity
                    highlighted: true
                    enabled: userTxt.isValid && passTxt.isValid && fullnameTxt.isValid && emailTxt.isValid && !usernameError.visible && !userCheckIndicator.running

                    Column {
                        spacing: 2 * Devices.density
                        anchors.left: sendBtn.left
                        anchors.right: sendBtn.right
                        anchors.top: sendBtn.bottom

                        MLabel {
                            id: usernameError
                            width: parent.width
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 8 * Devices.fontDensity
                            color: "#a00"
                            visible: false
                            text: qsTr("* Username you choosen taken.")
                        }

                        MLabel {
                            width: parent.width
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 8 * Devices.fontDensity
                            color: "#a00"
                            visible: !userTxt.isValid && !userTxt.focus && userTxt.length != 0
                            text: qsTr("* Your username must be 6 character at least and containt lower case characters and numbers only.")
                        }

                        MLabel {
                            width: parent.width
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 8 * Devices.fontDensity
                            color: "#a00"
                            visible: !passTxt.isValid && !passTxt.focus && passTxt.length != 0
                            text: qsTr("* Your password must be greater than 8 character and has one number or sign at least.")
                        }

                        MLabel {
                            width: parent.width
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 8 * Devices.fontDensity
                            color: "#a00"
                            visible: !fullnameTxt.isValid && !fullnameTxt.focus && fullnameTxt.length != 0
                            text: qsTr("* Your full name must be greater than 6 character.")
                        }

                        MLabel {
                            width: parent.width
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 8 * Devices.fontDensity
                            color: "#a00"
                            visible: !emailTxt.isValid && !emailTxt.focus && emailTxt.length != 0
                            text: qsTr("* Your email is invalid.")
                        }
                    }
                }
            }
        }
    }

    Header {
        id: headerItem
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Signup") + Translations.refresher
        color: Colors.headerColor
        light: !Colors.lightHeader
        shadow: Devices.isAndroid

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Devices.standardTitleBarHeight

            MButton {
                id: cancelBtn
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 8 * Devices.density
                text: qsTr("Cancel") + Translations.refresher
                highlighted: true
                radius: 6 * Devices.density
                font.pixelSize: 8 * Devices.fontDensity
            }
        }
    }
}



