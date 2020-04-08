import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Controls 2.0

AsemanApplication {
    id: app
    applicationAbout: "Meikade"
    applicationDisplayName: "Meikade"
    applicationId: "0e3103ed-dfb2-49df-95d2-3bcbec76fa34"
    organizationDomain: "meikade.com"
    Component.onCompleted: {
        AsemanApp.globalFont.family = globalFont
        if (Devices.isDesktop) Devices.fontScale = 1.1
    }

    property string globalFont: iran_sans.name + ", " + ubuntu_font.name + ", Noto Color Emoji"

    onGlobalFontChanged: AsemanApp.globalFont.family = globalFont

    FontLoader { id: iran_sans;            source: "fonts/IRANSans_Regular.ttf"}
    FontLoader { id: ubuntu_font;          source: "fonts/Ubuntu-R.ttf" }

    MainWindow {
        visible: true
        font.family: globalFont
    }
}
